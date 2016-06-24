#!/bin/bash

# Need an ssh host to run
if [ "$#" -ne 1 ]; then
    echo "Illegal number of arguments"
    exit 1
fi

echo
echo "Copying dotfiles"

dir=$(pwd)
scp -r "$dir" "$1":~/ > /dev/null
ssh "$1" "rm -rf ~/dotfiles/.git"

echo
read -p "Done. Press [Enter] to exit."
