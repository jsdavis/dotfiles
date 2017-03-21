#!/bin/bash

cd "$WINDOWS_HOME/AppData/Roaming/Sublime Text 3/Packages/User"
git pull &> /dev/null

git add --all &> /dev/null
git commit -am "Automatic commit" &> /dev/null
git push &> /dev/null
