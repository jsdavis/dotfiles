#!/bin/bash

# Need an ssh host to run
if [ "$#" -ne 1 ]; then
    echo "Illegal number of arguments"
    exit 1
fi

echo
echo "Updating dotfiles from remote host..."

dir=$(pwd)
scp -r "$1":~/dotfiles/* "$dir" > /dev/null

echo
echo "Done."
echo
