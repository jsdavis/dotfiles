#!/bin/bash

# Need an ssh host to run
if [ "$#" -ne 1 ]; then
    echo "Illegal number of arguments"
    exit 1
fi

echo
echo "Copying dotfiles..."

dir=$(pwd)
rsync -aru --exclude='.git/' "$dir" "$1":~/ > /dev/null

ssh -t "$1" "~/dotfiles/setup.py"

echo
echo "Done."
echo
