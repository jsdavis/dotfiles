export DOTFILES=~/dotfiles
export RC=.zshrc


# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/.local/bin:$DOTFILES/bin:$PATH

# Prompt is shortened when default user is on
DEFAULT_USER=jsdavis

if [ -f ~/.sharedrc ]; then
  source ~/.sharedrc
fi

# Tab completion for virtualenv helper functions created in .sharedrc
if func_exists lsenvs; then
  _env_compl() {
    reply=( "${(ps:\n:)$(lsenvs)}" )
  }
  compctl -K _env_compl workon
  compctl -K _env_compl rmenv
  compctl -K _env_compl inspect_env
fi

# Path to your zsh configuration.
export ZSH=$DOTFILES/lib/zsh

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Use agnoster virtualenv, not default
VIRTUAL_ENV_DISABLE_PROMPT="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load? (plugins can be found in $DOTFILES/plugins/*)
# Add wisely, as too many plugins slow down shell startup.
plugins=(fast-syntax-highlighting fzf zoxide colored-man-pages extract command-not-found zsh-autosuggestions local-completions)

###############################################################################
# Initializes Oh My Zsh

# add a function path
fpath=($ZSH/functions $ZSH/completions $fpath)

# Enable brew completions
if type brew &>/dev/null; then
  fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
fi

# Load all stock functions (from $fpath files) called below.
autoload -U compaudit compinit

: ${ZSH_DISABLE_COMPFIX:=true}

# Set ZSH_CACHE_DIR to the path where cache files should be created
ZSH_CACHE_DIR="$ZSH/cache"

# Load all of the config files in zsh dir that end in .zsh
for config_file ($ZSH/lib/*.zsh); do
  source $config_file
done
unset config_file

is_plugin() {
  local base_dir=$1
  local name=$2
  test -f $base_dir/plugins/$name/$name.plugin.zsh \
    || test -f $base_dir/plugins/$name/_$name
}

# Add all defined plugins to fpath. This must be done
# before running compinit.
for plugin ($plugins); do
  if is_plugin $ZSH $plugin; then
    fpath=($ZSH/plugins/$plugin $fpath)
  fi
done

# Figure out the SHORT hostname
if [[ "$OSTYPE" = darwin* ]]; then
  # macOS's $HOST changes with dhcp, etc. Use ComputerName if possible.
  SHORT_HOST=$(scutil --get ComputerName 2>/dev/null) || SHORT_HOST=${HOST/.*/}
else
  SHORT_HOST=${HOST/.*/}
fi

# Save the location of the current completion dump file.
ZSH_COMPDUMP="${ZDOTDIR:-${HOME}}/.zcompdump-${SHORT_HOST}-${ZSH_VERSION}"

if [[ $ZSH_DISABLE_COMPFIX != true ]]; then
  # If completion insecurities exist, warn the user without enabling completions.
  if ! compaudit &>/dev/null; then
    # This function resides in the "lib/compfix.zsh" script sourced above.
    handle_completion_insecurities
  # Else, enable and cache completions to the desired file.
  else
    compinit -d "${ZSH_COMPDUMP}"
  fi
else
  compinit -i -d "${ZSH_COMPDUMP}"
fi

# Load all of the plugins that were defined in ~/.zshrc
for plugin ($plugins); do
  if [ -f $ZSH/plugins/$plugin/$plugin.plugin.zsh ]; then
    source $ZSH/plugins/$plugin/$plugin.plugin.zsh
  fi
done


# Load the theme
source "$ZSH/zsh-theme"

# Set personal aliases, overriding any made by plugins
# For a full list of active aliases, run `alias`.
source ~/.aliases

autoload -Uz compinit
zstyle ':completion:*' menu select
fpath+=~/.zfunc

# export to global and dedupe entries (lowercase are arrays that shadow PATH, FPATH, etc).
# zsh docs recommend setting the flag for both interfaces.
typeset -gU cdpath PATH path FPATH fpath MANPATH manpath

