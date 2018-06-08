# TODO: Add DOTFILES portability
echo "Starting .bashrc"

# start zsh if it exists
if [ -x "$(command -v zsh)" ]; then
    exec zsh
else

    # I want my bash stuff when root
    if [[ $SUDO_USER ]]; then
        if [[ $OSTYPE == darwin* ]]; then
            export DOTFILES=/Users/$SUDO_USER/dotfiles
        else
            export DOTFILES=/home/$SUDO_USER/dotfiles
        fi
    else
        export DOTFILES=~/dotfiles
    fi

    # Add useful git things
    source "$DOTFILES/git/git-completion.bash"
    source "$DOTFILES/git/git-prompt.sh"

    # .bashrc.local if applicable
    if [ -f ~/.bashrc.local ]; then
        source ~/.bashrc.local
    fi

    # Set the prompt to '$|#[Working Dir](git branch *|+|%)-> '
    # \[\e[1;35m\]          --> Purple
    # \$                    --> $ for user, # for root
    # \[\e[0;34m\]          --> Blue
    # \w                    --> Working directory
    # \[\e[0;32m\]          --> Green
    # $(__git_ps1 "(%s)")   --> Display git branch as (branch)
    # \[\e[1;35m\]          --> Purple
    # ->                    --> "-> "
    # \[\e[0m\]             --> Default color

    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWUNTRACKEDFILES=1

    export PS1='\[\e[1;35m\]\$\[\e[0;34m\][\w]\[\e[0;32m\]$(__git_ps1 "(%s)")\[\e[1;35m\]-> \[\e[0m\]'

    PROMPT_DIRTRIM=3

    # Import custom ls colors if they exist
    [ -e $DOTFILES/lscolors.sh ] && eval $(dircolors -b $DOTFILES/lscolors.sh) || eval $(dircolors -b)

    ###############################################################################
    # History things

    # don't put duplicate lines or lines starting with space in the history.
    HISTCONTROL=ignoreboth

    # append to the history file
    shopt -s histappend

    # for setting history length
    HISTSIZE=1000
    HISTFILESIZE=2000

    # check the window size after each command and update lines/cols
    shopt -s checkwinsize


    export RC=.bashrc
    export PROFILE=.bash_profile
    source ~/.aliases

    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi


