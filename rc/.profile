# $PROFILE should be initialized by the calling shell
# $PROF_SHELL should be initialized by the calling shell

# $PROFILE.local if applicable
if [ -f ~/"$PROFILE.local" ]; then
    source ~/"$PROFILE.local"
fi

# If we're on a mac and have iTerm2, activate shell integration
if [[ $OSTYPE == "darwin"* ]] && [ -f ~/.iterm2_shell_integration."$PROF_SHELL" ]; then
    source ~/.iterm2_shell_integration."$PROF_SHELL"
fi

if [ -d "$HOME/.pyenv" ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    if command -v pyenv; then
        eval "$(pyenv init --path)"
    fi
fi
