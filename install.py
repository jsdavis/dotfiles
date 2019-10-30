#!/usr/bin/env python

from __future__ import print_function

import argparse
import os
import glob
import errno
import shutil
import filecmp
import sys
from functools import partial, wraps

# Got this from StackOverflow and it works so don't touch it
magic_powershell_command = 'powershell.exe -command "&{ start-process powershell -ArgumentList \'-executionpolicy bypass -command \"C:\\font\\Add-Font.ps1 C:\\font\\fonts\"\' -verb RunAs}"'


class NotSupportedError(Exception):
    pass


def platform():
    if sys.platform == 'darwin':
        return 'mac'
    elif os.path.isdir('/mnt/c/Windows'):
        return 'wsl'
    elif os.path.exists('/etc/redhat-release'):
        return 'rhel'
    else:
        return 'linux'


def ask_user(question):
    ans = 'ans'
    while ans and not (ans.startswith('n') or ans.startswith('y')):
        ans = raw_input(question)
        ans = ans.strip().lower()
    return not (ans.startswith('n'))


def install(func=None, platforms=None, ask=None, name=None, order=10):
    if func is None:
        return partial(install, platforms=platforms, ask=ask, name=None, order=order)

    if platforms is None:
        platforms = ('wsl', 'mac', 'linux', 'rhel')

    func.is_install_step = True
    func.supported = platform() in platforms
    func.ask = '\n{} (y)/n '.format(ask) if ask is not None else None
    func.order = order
    func.pretty_name = name if name is not None else func.__name__.replace('_', ' ').title()

    @wraps(func)
    def decorator(self, skip_ask, *args, **kwargs):
        if not func.supported:
            raise NotSupportedError('This operation is not supported on the {} platform'.format(platform()))

        func.run = skip_ask or (ask_user(func.ask) if func.ask is not None else True)
        if func.run:
            if not self.dry_run:
                return func(self, *args, **kwargs)
            else:
                print('DRY RUN: INSTALL STEP "{}"'.format(func.pretty_name))
        else:
            print('{} will not be installed.'.format(func.pretty_name))
    return decorator


class Installer(object):
    def __init__(self):
        self.platform = platform()
        self.dir = os.path.dirname(os.path.abspath(__file__))

        self.rc_dir = os.path.join(self.dir, 'rc')
        self.font_dir = os.path.join(self.dir, 'bin', 'font')

    @property
    def args(self):
        if not hasattr(self, '_args'):
            parser = argparse.ArgumentParser(description='Dotfiles installer by @jsdavis')
            parser.add_argument('--no-prompts', action='store_true',
                                help='Run all compatible tasks without prompting')
            parser.add_argument('--dry-run', action='store_true')

            group = parser.add_argument_group(title='Tasks',
                description='Explicit task flags. Giving none of these is equivalent to saying "run all tasks"')

            for install in self.get_installs():
                name = install.__name__
                help_str = install.__doc__ if install.__doc__ else 'Perform "{}" task.'.format(name)
                group.add_argument('--{}'.format(name.replace('_', '-')), action='store_true', help=help_str)

            self._args = vars(parser.parse_args())
            self._dry_run = self._args.pop('dry_run', False)

        return self._args

    @property
    def dry_run(self):
        if not hasattr(self, '_dry_run'):
            self._dry_run = self.args.pop('dry_run', False)
        return self._dry_run

    def run(self):
        skip_default = self.args.pop('no_prompts', False)
        run_all = not any(self.args.values())

        for install in self.get_installs():
            specified = self.args.get(install.__name__, False)

            if run_all or specified:
                skip_ask = skip_default or specified
                install(self, skip_ask)

        print("\nInstallation complete!")

    def run_cmd(self, cmd):
        print('-' * 50)
        print(cmd)
        result = os.system(cmd)
        print('-' * 50)
        return result

    @classmethod
    def get_installs(cls, supported_only=True):
        installs = (getattr(cls, func) for func in dir(cls) if cls._is_install(func))
        if supported_only:
            installs = (install for install in installs if install.supported)
        return sorted(installs, key=lambda x: x.order)

    @classmethod
    def _is_install(cls, method):
        try:
            if not callable(method):
                method = getattr(cls, method)
            return method.is_install_step
        except AttributeError:
            return False

    @install(ask='Do you want to install dotfiles?', order=0)
    def dotfiles(self):
        """
        Install bash, zsh, and vim configurations to this user's home
        """
        print("\nSetting up dotfiles...\n")

        # For Windows filesystem compatability
        home = os.path.expanduser("~")

        # Get list of dotfiles in rc directory
        files = glob.glob(os.path.join(self.rc_dir, ".*"))

        # Create symlinks to found dotfiles as necessary
        for dotfile in files:
            filename = os.path.basename(dotfile)
            homeLink = os.path.join(home, filename)

            # If symlink already exists, first remove it
            if os.path.islink(homeLink):
                os.unlink(homeLink)

            # Don't clobber dotfiles that exist already
            try:
                # Don't backup dotfiles that are the same
                if not filecmp.cmp(homeLink, dotfile, False):
                    os.rename(homeLink, homeLink + ".bak")
                    print("\t{0} exists. Moved to {0}.bak".format(filename))

                # Delete original if same. Not efficient, but cleaner logic
                else:
                    os.remove(homeLink)

            except OSError as err:
                if errno.errorcode[err.errno] == 'EISDIR':
                    if os.path.islink(homeLink):
                        os.unlink(homeLink)
                    else:
                        shutil.rmtree(homeLink)

            os.symlink(dotfile, homeLink)

        # We're done!
        print("Dotfile setup complete.")

    @install(platforms=['wsl', 'mac'], ask='Do you want to install fonts?')
    def fonts(self):
        """
        Install special Powerline font for cool symbols
        """
        if self.platform == 'wsl':
            return self._wsl_fonts()
        elif self.platform == 'mac':
            return self._mac_fonts()

    def _mac_fonts(self):
        font_install_dir = '/Library/Fonts'

        for font in glob.glob(os.path.join(self.font_dir, 'fonts/*.ttf')):
            font_file = os.path.basename(font)
            try:
                shutil.copyfile(font, os.path.join(font_install_dir, font_file))
            except OSError as err:
                if errno.errorcode[err.errno] == 'EEXIST':
                    print('{} is already installed'.format(font_file))
                else:
                    raise
            else:
                print('Installed font {}'.format(font_file))

    def _wsl_fonts(self):
        c_font = '/mnt/c/font'

        # First check if fonts are already installed
        if self._fonts_installed_wsl(c_font):
            print("\tFonts are already installed.")
            return

        try:
            # Copy fonts to a folder on the Windows filesystem
            shutil.copytree(os.path.join(self.font_dir), c_font)
            print("\tFonts copied to {0} directory".format(c_font))

            os.chdir(c_font)
            if self.run_cmd(magic_powershell_command) == 0:
                if self._fonts_installed_wsl(c_font):
                    print("\tFonts successfully installed\n\tCleaning up...")
                    os.chdir(self.dir)
                    shutil.rmtree(c_font)
                else:
                    self._manual_font_installation_wsl()
                    os.chdir(self.dir)
            else:
                self._manual_font_installation_wsl()
                os.chdir(self.dir)

        except OSError as err:
            if errno.errorcode[err.errno] == 'EEXIST':
                print("{} directory already exists. Nothing was copied".format(c_font))
            else:
                raise

    def _fonts_installed_wsl(self, font_dir):
        installed_fonts = [os.path.basename(font) for font in glob.glob('/mnt/c/Windows/Fonts/*.ttf')]
        attempted_fonts = [os.path.basename(font) for font in glob.glob(os.path.join(font_dir, '*.ttf'))]
        for font in attempted_fonts:
            if font not in installed_fonts:
                return False
        return True

    def _manual_font_installation_wsl(self):
        print("\tAn error occurred installing fonts. Opening folder for manual installation")
        self.run_cmd('explorer.exe fonts')

    @install(platforms=['mac'], ask='Configure MacOS settings?')
    def mac_settings(self):
        """
        Fix some mac settings, like showing hidden files, fixing accent key behavior, and mouse stuff
        """
        commands = [
            'defaults write com.apple.finder AppleShowAllFiles YES',  # Show hidden files
            'defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false',  # No accents on holding keys
            'defaults write .GlobalPreferences com.apple.mouse.scaling -1',  # Turn off mouse acceleration
            'defaults write .GlobalPreferences com.apple.scrollwheel.scaling -1'  # Turn off scroll acceleration
        ]
        for cmd in commands:
            self.run_cmd(cmd)

    @install(platforms=['mac'], ask='Install MacOS packages?', order=1)
    def mac_apps(self):
        """
        Install xcode and homebrew
        """
        commands = [
            # XCode dev tools, includes git
            'xcode-select --install',

            # Homebrew and Homebrew cask.
            '/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"',
            'brew update',
            'brew analytics off',
            'brew tap caskroom/cask'
        ]
        for cmd in commands:
            self.run_cmd(cmd)

    @install(platforms=['mac'], ask='Install Homebrew packages?')
    def brew_apps(self):
        """
        Install useful MacOS CLI applications view homebrew
        """
        packages = ['pyenv-virtualenv', 'wget', 'rename', 'fasd']
        cmd = 'brew install {}'.format(' '.join(p for p in packages))
        self.run_cmd(cmd)

    @install(platforms=['mac'], ask='Install Homebrew casks?', order=100)
    def brew_casks(self):
        """
        Install useful MacOS UI applications via homebrew cask
        """
        casks = ['iterm2', 'sublime-text', 'google-chrome', 'slack', 'postman', 'docker', 'spotify']
        cmd = 'brew cask install {}'.format(' '.join(c for c in casks))
        self.run_cmd(cmd)

    @install(ask='Install NVM?')
    def nvm(self):
        """
        Download and install Node Version Manager
        """
        cmd = \
            'git clone https://github.com/creationix/nvm.git {0} && ' \
            'cd {0} && ' \
            'git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`; ' \
            'cd {1}'.format(os.path.join(os.path.expanduser('~'), '.nvm'), self.dir)
        self.run_cmd(cmd)

    @install(platforms=['rhel'], ask='Install zsh and set as default shell?')
    def zsh(self):
        """
        Download and install zsh if not present, and set it as this user's default shell
        """
        zsh_installed = self.run_cmd('which zsh') == 0
        cmds = []

        if not zsh_installed:
            rpm_url = 'http://mirror.ghettoforge.org/distributions/gf/el/7/plus/x86_64/zsh-5.1-1.gf.el7.x86_64.rpm'
            cmds.extend([
                'curl -o zsh.rpm {}'.format(rpm_url),
                'sudo rpm -Uvh zsh.rpm',
                'rm -f zsh.rpm'
            ])
        cmds.append('chsh -s $(which zsh)')

        for cmd in cmds:
            self.run_cmd(cmd)

    @install(platforms=['rhel'], ask='Install yum packages?')
    def yum_packages(self):
        """
        Install useful yum packages
        """
        packages = ['fasd']
        cmd = 'sudo yum install -y {}'.format(' '.join(p for p in packages))
        self.run_cmd(cmd)


def main():
    return Installer().run()


if __name__ == '__main__':
    main()
