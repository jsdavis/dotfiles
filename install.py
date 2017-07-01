#!/usr/bin/env python

import os
import glob
import errno
import shutil
import filecmp

# Got this from StackOverflow and it works so don't touch it
magic_powershell_command = 'powershell.exe -command "&{ start-process powershell -ArgumentList \'-executionpolicy bypass -command \"C:\\font\\Add-Font.ps1 C:\\font\\fonts\"\' -verb RunAs}"'

def check_input(raw):
    return not (raw.lower() == 'n' or raw.lower() == 'no')

def system_type():
    if os.path.isdir('/mnt/c/Windows'):
        return 'WSL'
    else:
        return 'Other'

def fonts_installed(font_dir):
    installed_fonts = [os.path.basename(font) for font in glob.glob('/mnt/c/Windows/Fonts/*.ttf')]
    attempted_fonts = [os.path.basename(font) for font in glob.glob(os.path.join(font_dir, '*.ttf'))]
    for font in attempted_fonts:
        if font not in installed_fonts:
            return False
    return True

def manual_font_installation():
    print "\tAn error occurred installing fonts. Opening folder for manual installation"
    os.system('explorer.exe fonts')

def dotfiles():
    print "\nSetting up dotfiles...\n"

    # Get absolute path of current directory
    curr_dir = os.path.dirname(os.path.abspath(__file__))

    # For Windows filesystem compatability
    home = os.path.expanduser("~")

    # Get list of dotfiles in rc directory
    files = glob.glob(os.path.join(curr_dir,"rc",".*"))

    # Create symlinks to found dotfiles as necessary
    for dotfile in files:
        filename = os.path.basename(dotfile)
        homeLink = os.path.join(home,filename)

        # Don't clobber dotfiles that exist already
        try:
            # Don't backup dotfiles that are the same
            if not filecmp.cmp(homeLink, dotfile, False):
                os.rename(homeLink, homeLink + ".bak")
                print "\t{0} exists. Moved to {0}.bak".format(filename)

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
    print "Dotfile setup complete."

def install_fonts():
    # This only works on WSL for now
    if system_type() == 'WSL':
        c_font = '/mnt/c/font'

        # First check if fonts are already installed
        if fonts_installed(c_font):
            print "\tFonts are already installed."
            return

        try:
            # Copy fonts to a folder on the Windows filesystem
            shutil.copytree(os.path.join(curr_dir, 'scripts/font'), c_font)
            print "\tFonts copied to {0} directory".format(c_font)

            os.chdir(c_font)
            if os.system(magic_powershell_command) == 0:
                if fonts_installed(c_font):
                    print "\tFonts successfully installed\n\tCleaning up..."
                    os.chdir(curr_dir)
                    shutil.rmtree(c_font)
                else:
                    manual_font_installation()
                    os.chdir(curr_dir)
            else:
                manual_font_installation()
                os.chdir(curr_dir)

        except OSError as err:
            if errno.errorcode[err.errno] == 'EEXIST':
                print "{0} directory already exists. Nothing was copied".format(c_font)
            else:
                raise
    else:
        print "\nThere is no support for non-WSL systems at this time."


# Do we want to install dotfiles?
do_dotfiles = raw_input('\nInstall dotfiles? (y) ')
if check_input(do_dotfiles):
    dotfiles()
else:
    print "Dotfiles will not be installed."

# Do we want to install fonts?
do_fonts = raw_input('\nInstall powerline fonts? (y) ')
if check_input(do_fonts):
    install_fonts()
else:
    print "No fonts will be installed"

print "Installation complete!"
