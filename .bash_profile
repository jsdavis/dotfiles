# I want my bash stuff when in root
if [[ $SUDO_USER ]]; then
    export BASH_HOME=/home/$SUDO_USER
else
    export BASH_HOME=~
fi

source "$BASH_HOME/.bashrc"

# If OSX and we have iTerm2, activate shell integration
if [[ $OSTYPE == darwin* ]]; then
    if [ -f ~/.iterm2_shell_integration.bash ]; then
        source ~/.iterm2_shell_integration.bash
    fi
fi
