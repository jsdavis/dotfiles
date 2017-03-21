#!/bin/bash

cd "$WINDOWS_HOME/AppData/Roaming/Sublime Text 3/Packages/User"
git pull

git add --all
git commit -am "Automatic commit"
git push
