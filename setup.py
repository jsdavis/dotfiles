#!/usr/bin/env python

import os
import glob
import errno
import shutil
import filecmp
import platform

print "\nSetting up dotfiles...\n"

# Get absolute path of current directory
curr_dir = os.path.dirname(os.path.abspath(__file__))

# For Windows filesystem compatability
slash = "\\" if platform.system() == "win32" else "/"
home = os.path.expanduser("~") + slash

# Are we running in sudo (Linux only)
sudo = False
if home == '/root/':
    sudo = True
    home = '/home/' + os.environ['SUDO_USER'] + '/'

# Get list of dotfiles in current directory
files = glob.glob(curr_dir + slash + "rc" + slash + ".*")
#for file in files:
    # Remove directories from list, except .iterm2/
    # if os.path.isdir(file) and file.split(slash)[-1] != '.iterm2':
        # files.remove(file)

# Create symlinks to found dotfiles as necessary
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

    except OSError as err:
        if errno.errorcode[err.errno] == 'EISDIR':
            if os.path.islink(homefile):
                os.unlink(homefile)
            else:
                shutil.rmtree(homefile)

    os.symlink(file, homefile)

    # Set up root environment too
    if sudo:
        rootfile = '/root/' + filename

        # Don't clobber things that exist
        try:
            # Don't backup things that are the same
            if not filecmp.cmp(rootfile, homefile, False):
                os.rename(rootfile, rootfile + ".bak")
                print "{0} exists. Moved to {0}.bak".format(rootfile)

            # Delete original if same. Not efficient, but cleaner logic
            else:
                os.remove(rootfile)

        except OSError:
            pass

        # Just copy the newly created symlinks into the root directory
        os.symlink(file, rootfile)

# We're done!
print "Symlinks to the dotfiles have been created."
