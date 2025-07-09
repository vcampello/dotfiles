set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx SHELL fish

fish_add_path $HOME/bin

# source brew
if test -f /home/linuxbrew/.linuxbrew/bin/brew
    # linux
    /home/linuxbrew/.linuxbrew/bin/brew shellenv | source
else if test -f /opt/homebrew/bin/brew # macos
    # macos
    /opt/homebrew/bin/brew shellenv | source
end

# activate mise by default
mise activate fish | source

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
