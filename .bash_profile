source ~/.bashrc

# If OSX and we have iTerm2, activate shell integration
if [[ $OSTYPE == darwin* ]]; then
    if [ -f ~/.iterm2_shell_integration.bash ]; then
        source ~/.iterm2_shell_integration.bash
    fi
fi
