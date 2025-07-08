export XDG_CONFIG_HOME="$HOME/.config"

# source brew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Commands to run in interactive sessions can go here
if status is-interactive
    # starship
    starship init fish | source

    # fzf
    fzf --fish | source
    export FZF_DEFAULT_OPTS=''

    # zoxide
    zoxide init --cmd cd fish | source

    # neovim
    export VISUAL='nvim' # default viewer
    export EDITOR='nvim' # default editor
    export MANPAGER='nvim +Man!' # default manpage pager
    export MANWIDTH=999 # manpage width
end
