# bootstrap shell without replacing the default because:
# - fish is being installed by brew
# - fish isn't posix compliant
# - I don't want to deal with chsh when setting up new machines

# prevent nested executions - aka what if I want to start zsh?
if [[ "$SHELL" == *fish* ]]; then
    echo -e "\033[1;33m[WARN]\033[0;m skipping start-fish.sh..."
    return
fi

# source brew
if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
    # linux
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [ -f /opt/homebrew/bin/brew ]; then
    # macos
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# replace current shell process with fish
exec fish
