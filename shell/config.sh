# Source NVM
export NVM_DIR="$HOME/.nvm"
# This loads nvm
[ -s "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh" ] && \. "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh"
# This loads nvm bash_completion
[ -s "/home/linuxbrew/.linuxbrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/home/linuxbrew/.linuxbrew/opt/nvm/etc/bash_completion.d/nvm"

# rust
export PATH="$PATH:$(brew --prefix rustup)/bin"

# go
GOBIN_PATH="$(go env GOPATH)/bin"
export PATH="$PATH:$GOBIN_PATH"

# Find out if we are using bash or zsh
shell_name=""
case "$SHELL" in
*bash)
    shell_name="bash"
    ;;
*zsh)
    shell_name="zsh"

    # allow fzf and zsh-vi-mode to play nice with each other
    export ZVM_INIT_MODE=sourcing
    # source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
    ;;
esac

if [[ -z $shell_name ]]; then
    echo "Unkown shell. Zoxide and fzf shell integration will not be setup"
else
    # starship
    eval "$(starship init ${shell_name})"
    # echo "Setting up zoxide and fzf to use $shell_name"
    # zoxide
    eval "$(zoxide init --cmd cd ${shell_name})"

    # Set up fzf key bindings and fuzzy completion
    eval "$(fzf --${shell_name})"
fi
