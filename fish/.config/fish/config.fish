# source brew
if test -f /home/linuxbrew/.linuxbrew/bin/brew
    # linux
    /home/linuxbrew/.linuxbrew/bin/brew shellenv | source
else if test -f /opt/homebrew/bin/brew
    # macos
    /opt/homebrew/bin/brew shellenv | source
end

fish_add_path $HOME/bin
set -gx SHELL (which fish) # only set after the initial setup above or this will not be set correctly 
set -gx XDG_CONFIG_HOME "$HOME/.config"

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

    # recursively install node packages
    abbr npma fd package.json --exec npm install --prefix={//}

    function dots
        cd ~/dotfiles
        nvim +"FzfLua combine pickers=files"
    end

    # git clone --bare repo and do some minor setup
    function gitc
        if not set -q argv[1]
            echo "No repository provided"
            return 1
        end

        if git rev-parse --git-dir >/dev/null 2>&1
            echo "Aborting. Already in a repository"
            return 1
        end

        set -f URL $argv[1]
        # extract repo name using shell expansion
        # the below is equivalent to the following bash parameter expansion `DIR="${URL#*/}"` 
        set -f DIR (string replace --regex '^[^/]*/' '' $URL)

        if test -d "$DIR"
            echo "$PWD/$DIR already exits"
            return 1
        end

        git clone --bare "$URL" "$DIR/.git"

        # remove empty dir if it failed
        if test $status -ne 0
            rmdir "$DIR"
            return 1
        end

        # Explicitly sets the remote origin fetch so we can fetch remote branches
        cd "$DIR"
        git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"

        # Gets all branches from origin
        git fetch origin
    end

    function lily
        # This script reconfigures my split keyboard when it conflicts.
        # It could do with better error handling but this is here only so I don't forget how to do it.

        # find the keyboard. There should be 3 - it's the one without anything extra
        set -f device_id $(xinput list --id-only 'Mechboards UK Lily58 R2G')
        if test $status -eq 0
            # set the layout to us and remove the swapcaps option (the layout always has caps in a different place)
            setxkbmap -verbose -device "$device_id" -layout us -option ""
            echo "Successfuly configured Lily58: $device_id"
        end
    end

    # zellij 
    # set -gx ZELLIJ_AUTO_ATTACH true
    # set -gx ZELLIJ_AUTO_EXIT true
    function zellij_tab_name_update_pre --on-event fish_preexec
        if set -q ZELLIJ
            set -l cmd_line (string split " " -- $argv)
            set -l process_name $cmd_line[1]
            if test -n "$process_name"
                command nohup zellij action rename-tab $process_name >/dev/null 2>&1
            end
        end
    end

    function zellij_tab_name_update_post --on-event fish_postexec
        if set -q ZELLIJ
            command nohup zellij action rename-tab (prompt_pwd) >/dev/null 2>&1
        end
    end
    zellij setup --generate-completion fish | source
    eval (zellij setup --generate-auto-start fish | string collect)
end
