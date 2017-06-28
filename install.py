#!/usr/bin/env python

import os
import glob
import errno
import shutil
import filecmp

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
    print "\n{0}...".format(filename)

    # Don't clobber dotfiles that exist already
    try:
        # Don't backup dotfiles that are the same
        if not filecmp.cmp(homeLink, dotfile, False):
            os.rename(homeLink, homeLink + ".bak")
            print "\t{0} exists. Moved to {0}.bak".format(filename)

        # Delete original if same. Not efficient, but cleaner logic
        else:
            print "\t{0} symlink already exists. No change will occur.".format(filename)
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


# If we're on WSL, move those powerline fonts to the Windows filesystem
s = raw_input('\nInstall powerline fonts? (y) ')
if s.lower() == 'n' or s.lower() == 'no':
    print "No fonts will be installed. Setup is complete"
    quit()

if os.path.isdir('/mnt/c/Windows'):
    print "\nWSL detected."
    win_usr = raw_input("\tPlease specify your Windows username to install fonts: ")
    win_usr = os.path.join('/mnt/c/Users/', win_usr, 'font')
    try:
        shutil.copytree(os.path.join(curr_dir, 'scripts', 'font'), win_usr)
        print "\tFonts copied to {0} directory".format(win_usr)

        os.chdir(win_usr)
        result = os.system('powershell.exe -executionpolicy bypass -command ".\\\Add-Font.ps1 fonts *> \\$null"')
        if result == 0:
            print "\tPowerline fonts have been installed"

            print "\tCleaning up..."
            os.chdir(curr_dir)
            shutil.rmtree(win_usr)
        else:
            print "\t Installing fonts failed. Opening the {0} directory for manual installation".format(win_usr)
            os.system('explorer.exe fonts')
            os.chdir(curr_dir)

    except OSError as err:
        if errno.errorcode[err.errno] == 'EEXIST':
            print "{0} directory already exists. Nothing was copied".format(win_usr)
