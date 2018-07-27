#!/bin/bash

echo 
echo "Setting up dotfiles..."
echo

dir=$(pwd)

echo ".bash_profile..."
if [ -f ~/.bash_profile ]; then
    echo "File exists. Moving to .bash_profile.old"
    mv ~/.bash_profile ~/.bash_profile.old > /dev/null
fi
ln -s $dir/.bash_profile ~/ > /dev/null
echo

echo ".bashrc..."
if [ -f ~/.bashrc ]; then
    echo "File exists. Moving to .bashrc.old"
    mv ~/.bashrc ~/.bashrc.old > /dev/null
fi
ln -s $dir/.bashrc ~/ > /dev/null
echo

echo ".vimrc..."
if [ -f ~/.vimrc ]; then
    echo "File exists. Moving to .vimrc.old"
    mv ~/.vimrc ~/.vimrc.old > /dev/null
fi
ln -s $dir/.vimrc ~/ > /dev/null
echo

if hash tmux 2>/dev/null; then
    echo ".tmux.conf..."
    if [ -f ~/.tmux.conf ]; then
        echo "File exists. Moving to .tmux.conf.old"
        mv ~/.tmux.conf ~/.tmux.conf.old > /dev/null
    fi
    ln -s $dir/.tmux.conf ~/ > /dev/null
    echo
fi

echo "Symlinks to the dotfiles have been created."
read -p "Done. Press [Enter] to finish."

# TODO add dotfiles location flexibility.
# Set environment variable here. Append it to bashrc
# Have bashrc use it to find git functions
