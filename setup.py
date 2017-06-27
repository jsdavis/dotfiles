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
            print "{0} exists. Moved to {0}.bak".format(filename)

        # Delete original if same. Not efficient, but cleaner logic
        else:
            print "{0} symlink already exists. No change will occur.".format(filename)
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
if os.path.isdir('/mnt/c/Windows'):
    print "\nWSL detected. Moving fonts..."
    try:
        shutil.copytree(os.path.join(curr_dir, 'font'), '/mnt/c/font')
        print "Fonts can be installed from /mnt/c/font directory"

    except OSError as err:
        if errno.errorcode[err.errno] == 'EEXIST':
            print "/mnt/c/font directory already exists. Nothing was copied"
