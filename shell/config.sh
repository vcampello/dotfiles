# Source NVM
export NVM_DIR="$HOME/.nvm"
# This loads nvm
[ -s "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh" ] && \. "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh" 
# This loads nvm bash_completion
[ -s "/home/linuxbrew/.linuxbrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/home/linuxbrew/.linuxbrew/opt/nvm/etc/bash_completion.d/nvm"

# Find out if we are using bash or zsh
shell_name=""
case "$SHELL" in
    *bash)
    shell_name="bash"
        ;;
    *zsh)
    shell_name="zsh"
        ;;
esac


if [[ -z $shell_name ]]; then
    echo "Unkown shell. Zoxide and fzf shell integration will not be setup"
else
    echo "Setting up zoxide and fzf to use $shell_name"
    # zoxide
    eval "$(zoxide init --cmd cd ${shell_name})"

    # Set up fzf key bindings and fuzzy completion
    eval "$(fzf --${shell_name})"
fi
