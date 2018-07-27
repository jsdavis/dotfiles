# $PROFILE should be initialized by the calling shell
# $PROF_SHELL should be initialized by the calling shell
echo ".profile loading"

# $PROFILE.local if applicable
if [ -f ~/"$PROFILE.local" ]; then
    source ~/"$PROFILE.local"
fi

# If we're on a mac and have iTerm2, activate shell integration
if [[ $OSTYPE == "darwin"* ]] && [ -f ~/.iterm2_shell_integration."$PROF_SHELL" ]; then
    source ~/.iterm2_shell_integration."$PROF_SHELL"
fi

source ~/."$PROF_SHELL"rc
