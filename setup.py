#!/usr/bin/env python2.7

import os
import glob
import filecmp
import platform

print "\nSetting up dotfiles...\n"

# Get setup directory
dir = os.path.dirname(os.path.abspath(__file__))

# Portability
slash = "\\" if platform.system() == "win32" else "/"
home = os.path.expanduser("~") + slash

# Get list of files to set up
files = glob.glob(dir + slash + ".*")
for file in files:
    # Remove directories from list
    if os.path.isdir(file):
        files.remove(file)

# Set up those files
for file in files:
    filename = file.split(slash)[-1]
    homefile = home + filename
    print "\n{0}...".format(filename)

    # Don't clobber dotfiles that exist already
    try:
        # Don't backup dotfiles that are the same
        if not filecmp.cmp(homefile, file, False):
            os.rename(homefile, homefile + ".bak")
            print "{0} exists. Moved to {0}.bak".format(filename)

        # Delete original if same. Not efficient, but cleaner logic
        else:
            os.remove(homefile)

    except OSError:
        pass

    os.symlink(file, homefile)

# We're done!
print "Symlinks to the dotfiles have been created."


# TODO
# Make .bashrc more flexible for path to git functions
