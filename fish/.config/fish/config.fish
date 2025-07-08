set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx SHELL fish

# source brew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Commands to run in interactive sessions can go here
if status is-interactive
    # starship
    starship init fish | source

    # fzf
    fzf --fish | source
    set -gx FZF_DEFAULT_OPTS ''

    # zoxide
    zoxide init --cmd cd fish | source

    # neovim
    set -gx VISUAL nvim # default viewer
    set -gx EDITOR nvim # default editor
    set -gx MANPAGER 'nvim +Man!' # default manpage pager
    set -gx MANWIDTH 999 # manpage width
end
