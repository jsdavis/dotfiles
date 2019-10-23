export RC=.bashrc
export PROFILE=.bash_profile

if [ -f ~/.sharedrc ]; then
    source ~/.sharedrc
fi

# Add useful git things
source "$DOTFILES/lib/git/git-completion.bash"
source "$DOTFILES/lib/git/git-prompt.sh"

###############################################################################
# Bash prompt (color codes used and functions for segments)
red='\[\e[1;31m\]'
white='\[\e[1;37m\]'
purple='\[\e[1;35m\]'
blue='\[\e[0;34m\]'
green='\[\e[0;32m\]'
clear='\[\e[0m\]'

PROMPT_DIRTRIM=3
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1

prompt_segment() {
  for i; do echo -n "$i"; done
}

prompt_context() {
  prompt_segment $purple '\$'
}

# Virtualenv: current working virtualenv if applicable
prompt_virtualenv() {
  if [[ -n $VIRTUAL_ENV && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
    prompt_segment $white "(`basename $VIRTUAL_ENV`)"
  fi
}

prompt_dir() {
  prompt_segment $blue '[\w]'
}

prompt_git() {
  [[ $DISABLE_GIT_PROMPT -eq 1 ]] && return
  prompt_segment $green '$(__git_ps1 "(%s)")'
}

prompt_end() {
  prompt_segment $purple '-> ' $clear
}

build_prompt() {
  RETVAL=$?
  prompt_context
  prompt_virtualenv
  prompt_dir
  prompt_git
  prompt_end
}

export PS1=$(build_prompt)

###############################################################################
# Virtualenv helper function completions. Functions declared in sharedrc

if func_exists lsenvs; then
  _env_compl() {
    if [ "${#COMP_WORDS[@]}" != "2" ]; then
        return
    fi
    COMPREPLY=($(compgen -W "$(lsenvs)" "${COMP_WORDS[1]}"))
  }
  complete -F _env_compl workon
  complete -F _env_compl rmenv
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
