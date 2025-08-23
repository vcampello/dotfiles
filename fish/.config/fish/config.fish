set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx SHELL (which fish)

fish_add_path $HOME/bin

# source brew
if test -f /home/linuxbrew/.linuxbrew/bin/brew
    # linux
    /home/linuxbrew/.linuxbrew/bin/brew shellenv | source
else if test -f /opt/homebrew/bin/brew
    # macos
    /opt/homebrew/bin/brew shellenv | source
end

# activate mise by default
mise activate fish | source
mise completion fish >~/.config/fish/completions/mise.fish # TODO: cache if this ever becomes a bottleneck

# Commands to run in interactive sessions can go here
if status is-interactive
    # starship
    starship init fish | source

    # fzf
    fzf --fish | source
    set -gx FZF_DEFAULT_OPTS ''
    # Preview file content using bat (https://github.com/sharkdp/bat)
    set -gx FZF_CTRL_T_OPTS "
      --walker-skip .git,node_modules,target
      --preview 'bat -n --color=always {}'
      --bind 'ctrl-/:change-preview-window(down|hidden|)'"

    # zoxide
    zoxide init --cmd cd fish | source

    # neovim
    set -gx VISUAL nvim # default viewer
    set -gx EDITOR nvim # default editor
    set -gx MANPAGER 'nvim +Man!' # default manpage pager
    set -gx MANWIDTH 999 # manpage width

    # grc
    source $HOMEBREW_PREFIX/etc/grc.fish

    function dots
        cd ~/dotfiles
        nvim +"FzfLua combine pickers=files"
    end

    # recursively install node packages
    abbr npma fd package.json --exec npm install --prefix={//}
end
