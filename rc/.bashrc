export RC=.bashrc
export PROFILE=.bash_profile

if [ -f ~/.sharedrc ]; then
    source ~/.sharedrc
fi

# Add useful git things
source "$DOTFILES/lib/git/git-completion.bash"
source "$DOTFILES/lib/git/git-prompt.sh"

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

###############################################################################
# Virtualenv helper function completions. Functions declared in sharedrc

if func_exists ls_envs; then
  _env_compl() {
    if [ "${#COMP_WORDS[@]}" != "2" ]; then
        return
    fi
    COMPREPLY=($(compgen -W "$(ls_envs)" "${COMP_WORDS[1]}"))
  }
  complete -F _env_compl activate
  complete -F _env_compl cp_env
  complete -F _env_compl mv_env
  complete -F _env_compl rm_env
  complete -F _env_compl inspect_env
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

source ~/.aliases
