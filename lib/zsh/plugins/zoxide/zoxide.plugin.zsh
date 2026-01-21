if [ ! $commands[zoxide] ]; then
    if [[ $commands[brew] ]]; then
        brew install zoxide
    elif [[ $commands[curl] ]]; then
        curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
    fi
fi

if [ $commands[zoxide] ]; then
    eval "$(zoxide init --cmd z zsh)"
fi
