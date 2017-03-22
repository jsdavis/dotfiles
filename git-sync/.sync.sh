#!/bin/bash

source ~/.bashrc.local

cd ~/dotfiles/git-sync
./sublime.sh > /dev/null
./dotfiles.sh > /dev/null
