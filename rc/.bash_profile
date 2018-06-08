# start zsh if it exists
if [ -x "$(command -v zsh)" ]; then
    exec zsh
else

    # .bash_profile.local if applicable
    if [ -f ~/.bash_profile.local ]; then
        source ~/.bash_profile.local
    fi

    source ~/.bashrc

    # If we have iTerm2, activate shell integration
    if [ -f ~/.iterm2_shell_integration.bash ]; then
            source ~/.iterm2_shell_integration.bash
    fi

fi
