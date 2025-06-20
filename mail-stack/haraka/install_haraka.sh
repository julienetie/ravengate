#!/bin/bash
set -e

PKG="Haraka"
NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

# Load nvm if available
if [ -s "$NVM_DIR/nvm.sh" ]; then
    echo "Loading nvm..."
    \. "$NVM_DIR/nvm.sh"
    
    # Check if Node 24 is available and use it
    if nvm list | grep -q "v24"; then
        echo "Switching to Node 24..."
        nvm use 24
    else
        echo "Node 24 not found. Available versions:"
        nvm list
        echo "Please install Node 24 first: nvm install 24"
        exit 1
    fi
else
    echo "nvm not found, using system Node"
fi

# Verify Node version
NODE_VERSION=$(node -v)
echo "Using Node version: $NODE_VERSION"

# Build paths after potentially switching Node versions
NODE_MODULES_DIR="$NVM_DIR/versions/node/$NODE_VERSION/lib/node_modules"
TARGET_DIR="$NODE_MODULES_DIR/$PKG"

echo "Target directory: $TARGET_DIR"

# Try to uninstall the package
echo "Attempting to uninstall $PKG..."
if npm uninstall -g "$PKG" 2>/dev/null; then
    echo "Successfully uninstalled $PKG via npm"
else
    echo "npm uninstall failed or package not found"
    
    # Check if the directory exists and remove it manually
    if [ -d "$TARGET_DIR" ]; then
        echo "Manually removing $TARGET_DIR"
        rm -rf "$TARGET_DIR"
    else
        echo "Package directory not found at $TARGET_DIR"
    fi
fi

# Also check for any symlinks in bin directory
BIN_DIR="$NVM_DIR/versions/node/$NODE_VERSION/bin"
if [ -d "$BIN_DIR" ]; then
    echo "Checking for $PKG symlinks in $BIN_DIR"
    find "$BIN_DIR" -name "*haraka*" -type l -delete 2>/dev/null || true
fi

# Clean npm cache
echo "Cleaning npm cache..."
npm cache clean --force

# Install the package
echo "Installing $PKG globally..."
npm install -g "$PKG"

# Verify installation
echo "Verifying installation..."
if command -v haraka >/dev/null 2>&1; then
    echo "✓ $PKG installed successfully"
    haraka --version
else
    echo "✗ $PKG installation may have failed"
    exit 1
fi
