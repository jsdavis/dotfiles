if [ ! $commands[fzf] ]; then
    if [[ $commands[brew] ]]; then
        brew install fzf
    fi
fi

if [ $commands[fzf] ]; then
    eval "$(fzf --zsh)"
fi
