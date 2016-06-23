# Add useful git things
for file in ~/dotfiles/git; do
    source $file
done

# .bashrc.local if applicable
if [ -f ~/.bashrc.local ]; then
    source ~/.bashrc.local
fi

# Set the prompt to '$|#(Working Dir)-> '
PS1='\[\033[1;35m\]\$\[\033[1;32m\]\w\[\033[1;35m\]-> \[\033[0;37m\]'

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

# Try not to clobber things
alias rm='rm -i'
alias mv='mv -i'

# Colorful command outputs
alias ls='ls -G'
alias dir='dir -G'
alias vdir='vdir -G'
alias grep='grep -G'
alias fgrep='fgrep -G'
alias egrep='egrep -G'

# ls aliases
alias ll='ls -alhF'
alias la='ls -A --group-directories-first'
alias l='ls -CF'
