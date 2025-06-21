#!/bin/bash

# Generate TLS certificates for Haraka
HARAKA_CONFIG_DIR="./mail-stack/haraka/service/config"

# Check if config directory exists
if [ ! -d "$HARAKA_CONFIG_DIR" ]; then
    echo "Error: Haraka config directory not found at $HARAKA_CONFIG_DIR"
    exit 1
fi

echo "Generating TLS certificates for Haraka..."

# Generate private key
openssl genrsa -out "$HARAKA_CONFIG_DIR/tls_key.pem" 2048

# Generate self-signed certificate
openssl req -new -x509 -key "$HARAKA_CONFIG_DIR/tls_key.pem" \
    -out "$HARAKA_CONFIG_DIR/tls_cert.pem" \
    -days 365 \
    -subj "/C=US/ST=Test/L=Test/O=Test/OU=Test/CN=localhost"

# Set appropriate permissions
chmod 600 "$HARAKA_CONFIG_DIR/tls_key.pem"
chmod 644 "$HARAKA_CONFIG_DIR/tls_cert.pem"

echo "✓ TLS certificates generated:"
echo "  - Private key: $HARAKA_CONFIG_DIR/tls_key.pem"
echo "  - Certificate: $HARAKA_CONFIG_DIR/tls_cert.pem"
