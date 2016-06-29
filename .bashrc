# TODO: Add DOTFILES portability

# I want my bash stuff when root
if [[ $SUDO_USER ]]; then
    export DOTFILES=/home/$SUDO_USER/dotfiles
else
    export DOTFILES=~/dotfiles
fi

# Add useful git things
source "$DOTFILES/git/git-completion.bash"
source "$DOTFILES/git/git-prompt.sh"

# Nice color variables
source "$DOTFILES/colors.sh"

# .bashrc.local if applicable
if [ -f ~/.bashrc.local ]; then
    source ~/.bashrc.local
fi

# Set the prompt to '$|#[Working Dir](git branch *|+|%)-> '
# \[$bldpur\]           --> Bold Purple
# \$                    --> $ for user, # for root
# \[$bldgrn\]           --> Bold Green
# \w                    --> Working directory
# \[$bldpur\]           --> Bold Purple
# \[$bldblu\]           --> Bold Blue
# $(__git_ps1 "(%s)")   --> Display git branch as (branch)
# ->                    --> "-> "
# \[$txtrst\]           --> Default color

GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
PS1="\[$bldpur\]\$\[$bldgrn\][\w]\[$bldblu\]$(__git_ps1 "(%s)")\[$bldpur\]-> \[$txtrst\]"

# Show host in ssh sessions
if [ -n "$SSH_TTY" ]; then
    export PS1="\[$bldcyn\]\h$PS1"
fi

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

###############################################################################
# Alias things

# Easy source
alias loadrc="source $DOTFILES/.bashrc"
alias loadpr="source $DOTFILES/.bash_profile"

# Try not to clobber things
alias rm='rm -i'
alias mv='mv -i'

# Colorful command outputs
case $OSTYPE in
    "linux-gnu")
        LS_OPTS="--color=auto"
        ;;
    darwin*)
        LS_OPTS="-G"
        ;;
esac

alias ls='ls $LS_OPTS'
alias dir='dir $LS_OPTS'
alias vdir='vdir $LS_OPTS'
alias grep='grep $LS_OPTS'
alias fgrep='fgrep $LS_OPTS'
alias egrep='egrep $LS_OPTS'

# ls aliases
alias l='ls -CF'
alias ll='ls -alhF'
alias la='ls -A'

# git aliases
alias gc='git commit -m'
alias gca='git commit -am'
alias gs='git status'
alias gco='git checkout'
alias gb='git branch'
alias ga='git add'
alias gd='git diff'
alias gpsh='git push'
alias gpul='git pull'
alias gf='git fetch'

# Why type more than one letter?
alias v='vim'
alias c='clear'

# For when we forget sudo
alias fuck='sudo $(history -p !!)'
alias FUCK='sudo "$BASH" -c "$(history -p !!)'

# For moving easily
alias .='cd ..'
alias ..='cd ../..'
alias ...='cd ../../..'
