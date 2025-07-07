#!/bin/bash

# setup brew
if [ ! -f "$(which brew)" ]; then
    # TODO: add confirmation prompt
    echo "Bootstrapping brew..."
    # Brew ask for confirmation on installation
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Brew found..."
fi

# FIXME: install stow, symlink files then install the bundle
# TODO: add confirmation prompt
# TODO: add checks to ensure the directories are correct
# setup tools
echo "installing brew bundle"

# link the brew config directory
brew_config_dir="$XDG_CONFIG_HOME/homebrew"
echo "Creating $brew_config_dir"
# symlink config
# FIXME: this feels hacky as hell
cd ../
ln -snv "${PWD}/homebrew/.config/homebrew/" "$brew_config_dir"
cd ./shell
# install bundle
brew bundle check --global && brew bundle --global

# TODO: verify if this will work on macos
# Setup env config for the script
# BASEDIR=$(dirname "$0")
# source "${BASEDIR}/config.sh"

# TODO: add confirmation prompt
RED='\033[0;31m'
RESET='\033[0m' # No Color
echo
echo -e "${RED}Don't forget to source \"${PWD}/config.sh\"${RESET}"
echo
