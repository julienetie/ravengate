#!/bin/bash

# Ask if user wants to install Haraka globally
read -p "(y) to install Haraka globally, (n) to continue with setup (y/n): " install_global

if [[ $install_global =~ ^[Yy]$ ]]; then
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
fi

#################################################################################
# Initialize Haraka 

# Remove specific haraka files/folders if they exist
if [ -d "./mail-stack/haraka/" ]; then
    echo "Removing existing haraka files..."
    rm -rf ./mail-stack/haraka/config
    rm -rf ./mail-stack/haraka/docs
    rm -f ./mail-stack/haraka/package.json
    rm -rf ./mail-stack/haraka/plugins
    rm -f ./mail-stack/haraka/README*
fi

haraka -i ./mail-stack/haraka/

# Update SMTP settings
cat <<EOF > ./mail-stack/haraka/config/smtp.ini 
listen=[::0]:2525,0.0.0.0:2525
max_connections=1000
EOF

# Update Plugins for inbound only
cat <<EOF > ./mail-stack/haraka/config/plugins
tls
auth/flat_file
rcpt_to.in_host_list
data.headers
stdout_delivery
EOF

# Update Host list
cat <<EOF > ./mail-stack/haraka/config/host_list
localhost
test.local
EOF

# Configure logging to stdout
cat <<EOF > ./mail-stack/haraka/config/log.ini
level=INFO
timestamps=true
format=DEFAULT
EOF

# Move stdout_delivery.js to plugins 
mv ./mail-stack/haraka/stdout_delivery.js ./mail-stack/haraka/plugins/
