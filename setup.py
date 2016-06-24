#!/usr/bin/env python2.7

import os
import glob
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
    if os.path.isdir(file):
        files.remove(file)

# Set up those files
for file in files:
    filename = file.split(slash)[-1]
    homefile = home + filename
    print "\n{0}...".format(filename)

    # Don't clobber dotfiles that exist already
    try:
        os.rename(homefile, homefile + ".bak")
        print "{0} exists. Moved to {0}.bak".format(filename)
    except OSError:
        pass

    os.symlink(file, homefile)
        
# We're done!
print "Symlinks to the dotfiles have been created."


# TODO
# Make .bashrc more flexible for path to git functions

# TODO
# Check if setup is replacing symlinks with the same symlink.
# Don't backup in that scenario
