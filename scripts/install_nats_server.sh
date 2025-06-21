#!/bin/bash

set -e

NATS_VERSION="$1"
INSTALL_DIR="/usr/local/bin"
NATS_BIN="$INSTALL_DIR/nats-server"
CONFIG_BACKUP_DIR="$HOME/nats-config-backup"
TMP_DIR=$(mktemp -d)

get_latest_version() {
  curl -s https://api.github.com/repos/nats-io/nats-server/releases/latest \
    | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/'
}

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

# Check if nats-server is already installed
if command -v nats-server &> /dev/null; then
  echo "nats-server is already installed at $NATS_BIN."
  read -p "Do you want to reinstall it? (y/n): " REINSTALL
  if [[ "$REINSTALL" != "y" ]]; then
    echo "Aborting installation."
    exit 0
  fi

  if [[ -f /etc/nats-server.conf ]]; then
    mkdir -p "$CONFIG_BACKUP_DIR"
    cp /etc/nats-server.conf "$CONFIG_BACKUP_DIR/nats-server.conf.$(date +%s)"
    echo "Backed up existing config to $CONFIG_BACKUP_DIR"
  fi

  sudo rm -f "$NATS_BIN"
fi

if [[ -z "$NATS_VERSION" ]]; then
  echo "Fetching latest version..."
  NATS_VERSION=$(get_latest_version)
  echo "Latest version is v$NATS_VERSION"
fi

TAR_NAME="nats-server-v$NATS_VERSION-linux-amd64.tar.gz"
DOWNLOAD_URL="https://github.com/nats-io/nats-server/releases/download/v$NATS_VERSION/$TAR_NAME"

echo "Downloading nats-server v$NATS_VERSION from $DOWNLOAD_URL..."
cd "$TMP_DIR"
HTTP_STATUS=$(curl -L --write-out "%{http_code}" --silent --output "$TAR_NAME" "$DOWNLOAD_URL")

if [[ "$HTTP_STATUS" -ne 200 ]]; then
  echo "Failed to download nats-server. HTTP status: $HTTP_STATUS"
  exit 1
fi

# Extract and install
tar -xzf "$TAR_NAME"
cd "nats-server-v$NATS_VERSION-linux-amd64"
sudo mv nats-server "$INSTALL_DIR/"
sudo chmod +x "$NATS_BIN"

# Verify
echo -n "Installed version: "
nats-server --version

