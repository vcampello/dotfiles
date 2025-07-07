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
