#!/bin/bash

set -e

NATS_CLI_VERSION="$1"
INSTALL_DIR="/usr/local/bin"
NATS_CLI_BIN="$INSTALL_DIR/nats"
TMP_DIR=$(mktemp -d)

# Function to get latest version
get_latest_version() {
  curl -s https://api.github.com/repos/nats-io/natscli/releases/latest \
    | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/'
}

# Cleanup function
cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

# Check if CLI already exists
if command -v nats &> /dev/null; then
  echo "NATS CLI is already installed at $NATS_CLI_BIN."
  read -p "Do you want to reinstall it? (y/n): " REINSTALL
  if [[ "$REINSTALL" != "y" ]]; then
    echo "Aborting."
    exit 0
  fi
  sudo rm -f "$NATS_CLI_BIN"
fi

# Get version
if [[ -z "$NATS_CLI_VERSION" ]]; then
  echo "Fetching latest NATS CLI version..."
  NATS_CLI_VERSION=$(get_latest_version)
  echo "Latest version is v$NATS_CLI_VERSION"
fi

ZIP_NAME="nats-${NATS_CLI_VERSION}-linux-amd64.zip"
DOWNLOAD_URL="https://github.com/nats-io/natscli/releases/download/v${NATS_CLI_VERSION}/$ZIP_NAME"

echo "Downloading NATS CLI v$NATS_CLI_VERSION..."
cd "$TMP_DIR"
HTTP_STATUS=$(curl -L --write-out "%{http_code}" --silent --output "$ZIP_NAME" "$DOWNLOAD_URL")

if [[ "$HTTP_STATUS" -ne 200 ]]; then
  echo "❌ Failed to download NATS CLI. HTTP status: $HTTP_STATUS"
  exit 1
fi

# Extract and install
if ! unzip -q "$ZIP_NAME"; then
  echo "❌ Failed to unzip $ZIP_NAME — corrupted or invalid archive."
  exit 1
fi

cd "nats-${NATS_CLI_VERSION}-linux-amd64"
sudo mv nats "$INSTALL_DIR/"
sudo chmod +x "$INSTALL_DIR/nats"

# Verify
echo -n "✅ Installed NATS CLI version: "
nats --version

