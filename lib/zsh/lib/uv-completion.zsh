if [ $commands[uv] ]; then
    autoload -U +X compinit && compinit
    eval "$(uv --generate-shell-completion zsh)"
    eval "$(uvx --generate-shell-completion zsh)"
fi
