if [ ! $commands[fasd] ]; then
    if [[ $commands[apt] ]]; then
        sudo apt-add-repository ppa:aacebedo/fasd
        sudo apt update
        sudo apt install fasd
    elif [[ $commands[apt-get] ]]; then
        sudo apt-add repository ppa:aacebedo/fasd
        sudo apt-get update
        sudo apt-get install fasd
    elif [[ $commands[brew] ]]; then
        brew install fasd
    else
        exit(1)
    fi
fi


fasd_cache="${ZSH_CACHE_DIR}/fasd-init-cache"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
fasd --init auto >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache

alias v="f -e $EDITOR"
alias o='a -e open_command'
