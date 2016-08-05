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

if [ -f ~/.iterm2_shell_integration.bash ]; then
    echo
    echo "Copying iterm files..."
    rsync -aru ~/.iterm* "$1":~/ > /dev/null
fi

echo
echo "Done."
echo
