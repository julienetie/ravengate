#!/bin/bash

set -euo pipefail

NVM_DIR="$HOME/.nvm"
NVM_INSTALL_URL="https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh"

# Confirm helper
confirm() {
    read -r -p "$1 [y/N]: " response
    case "$response" in
    [yY][eE][sS] | [yY]) true ;;
    *) false ;;
    esac
}

# Source NVM if already installed
if [ -s "$NVM_DIR/nvm.sh" ]; then
    echo "✓ NVM found. Sourcing existing NVM..."
    # shellcheck disable=SC1090
    . "$NVM_DIR/nvm.sh"

    if confirm "Do you want to reinstall NVM without deleting your Node versions or global packages?"; then
        echo "Backing up list of globally installed packages..."
        GLOBAL_PKG_LIST=$(npm ls -g --depth=0 --json | jq -r '.dependencies | keys[]')
        echo "$GLOBAL_PKG_LIST" >/tmp/nvm-global-packages.txt

        echo "Reinstalling NVM (non-destructive)..."
        curl -o- "$NVM_INSTALL_URL" | bash

        echo "Re-sourcing NVM..."
        # shellcheck disable=SC1090
        . "$NVM_DIR/nvm.sh"

        echo "Restoring global packages..."
        xargs -n1 npm install -g </tmp/nvm-global-packages.txt

        echo "Cleanup..."
        rm /tmp/nvm-global-packages.txt
    else
        echo "Keeping current NVM setup unchanged."
    fi
else
    echo "NVM not found. Installing fresh..."
    curl -o- "$NVM_INSTALL_URL" | bash

    echo "Sourcing NVM..."
    # shellcheck disable=SC1090
    . "$NVM_DIR/nvm.sh"
fi

echo "✓ NVM is ready."
echo "Node version: $(node -v)"
echo "NPM version: $(npm -v)"
