if command_exists uvx; then
    autoload -U +X compinit && compinit
    eval "$(uvx --generate-shell-completion zsh)"
fi
