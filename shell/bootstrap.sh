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

# TODO: add confirmation prompt
# setup tools
echo "Installing tools"
brew install \
    mise \
    stow

echo "installing fonts"
brew install --cask font-iosevka
brew install --cask font-victor-mono

# setup rust
# the path will be set in config.sh
rustup-init -y --no-modify-path

# TODO: verify if this will work on macos
# Setup env config for the script
BASEDIR=$(dirname "$0")
source "${BASEDIR}/config.sh"

# TODO: add confirmation prompt
RED='\033[0;31m'
RESET='\033[0m' # No Color
echo
echo -e "${RED}Don't forget to source \"${PWD}/config.sh\"${RESET}"
echo
