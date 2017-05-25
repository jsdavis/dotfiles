# start zsh if it exists
if [ -x "$(command -v zsh)" ]; then
    exec zsh
else

    # .bash_profile.local if applicable
    if [ -f ~/.bash_profile.local ]; then
        source ~/.bash_profile.local
    fi

    # I want my bash stuff when in root
    if [[ $SUDO_USER ]]; then
        export BASH_HOME=/home/$SUDO_USER
    else
        export BASH_HOME=~
    fi

    source "$BASH_HOME/.bashrc"

    # If we have iTerm2, activate shell integration
    if [ -f "$BASH_HOME/.iterm2_shell_integration.bash" ]; then
            source ~/.iterm2_shell_integration.bash
    fi

fi
