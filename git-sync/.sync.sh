#!/bin/bash

cd ~/dotfiles/git-sync
echo "Starting" > sync_out.txt
./*.sh
echo "Done" > sync_out.txt

