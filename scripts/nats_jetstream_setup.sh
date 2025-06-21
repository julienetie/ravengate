#!/bin/bash

set -e

CONFIG_DIR="/etc/nats"
CONFIG_FILE="$CONFIG_DIR/nats-server.conf"
DATA_DIR="/var/lib/nats/jetstream"
SYSTEMD_SERVICE="/etc/systemd/system/nats-server.service"
NATS_USER="nats"

# Create config directory
echo "Creating config directory: $CONFIG_DIR"
sudo mkdir -p "$CONFIG_DIR"

# Write the JetStream config
if [[ -f "$CONFIG_FILE" ]]; then
  echo "Config file already exists at $CONFIG_FILE — skipping overwrite."
else
  echo "Creating config at $CONFIG_FILE"
  sudo tee "$CONFIG_FILE" > /dev/null <<EOF
# Basic server config
port: 4222
http_port: 8222

# Enable JetStream
jetstream {
    # Store directory
    store_dir: "$DATA_DIR"

    # Max memory and storage
    max_memory_store: 1GB
    max_file_store: 10GB
}
EOF
fi

# Create JetStream data directory
echo "Ensuring JetStream data directory exists: $DATA_DIR"
sudo mkdir -p "$DATA_DIR"

# Create nats user if it doesn't exist
if id "$NATS_USER" &>/dev/null; then
  echo "User '$NATS_USER' already exists — skipping."
else
  echo "Creating system user '$NATS_USER'"
  sudo useradd -r -s /bin/false "$NATS_USER"
fi

# Set correct ownership
echo "Setting ownership of /var/lib/nats to $NATS_USER"
sudo mkdir -p /var/lib/nats
sudo chown -R "$NATS_USER:$NATS_USER" /var/lib/nats

# Create systemd service
if [[ -f "$SYSTEMD_SERVICE" ]]; then
  echo "Systemd service already exists at $SYSTEMD_SERVICE — skipping overwrite."
else
  echo "Creating systemd service at $SYSTEMD_SERVICE"
  sudo tee "$SYSTEMD_SERVICE" > /dev/null <<EOF
[Unit]
Description=NATS Server
After=network.target

[Service]
Type=simple
User=$NATS_USER
Group=$NATS_USER
ExecStart=/usr/local/bin/nats-server -c $CONFIG_FILE
Restart=always
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF
fi

# Reload systemd and start the service
echo "Reloading systemd daemon..."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload

echo "Enabling and starting nats-server service..."
sudo systemctl enable nats-server
sudo systemctl start nats-server

echo "✅ NATS JetStream setup complete."

