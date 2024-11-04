#!/bin/bash

# Define the Caddy version to use
caddyVersion="2.1.1"

# Function to install Go if it's not already installed
install_go() {
    echo "Installing Go..."
    wget -q https://dl.google.com/go/go1.19.4.linux-amd64.tar.gz  # Update to the latest version as needed
    sudo tar -C /usr/local -xzf go1.19.4.linux-amd64.tar.gz
    echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.profile
    source ~/.profile
    rm go1.19.4.linux-amd64.tar.gz
}

# Check if Go is installed; if not, install it
if ! command -v go &> /dev/null; then
    install_go
else
    echo "Go is already installed"
fi

# Download xcaddy if it's not already present
if [ ! -f ./xcaddy ]; then
    echo "Downloading xcaddy..."
    curl -s -O -L https://github.com/caddyserver/xcaddy/releases/download/v0.2.0/xcaddy_0.2.0_linux_amd64.tar.gz
    tar xf xcaddy_0.2.0_linux_amd64.tar.gz
    mv xcaddy caddy  # Rename xcaddy to caddy if desired
    rm xcaddy_0.2.0_linux_amd64.tar.gz
fi

# Build Caddy with the Cloudflare DNS provider
echo "Building Caddy with Cloudflare DNS provider..."
./caddy build v${caddyVersion} --with github.com/caddy-dns/cloudflare

# Enable Caddy to bind low ports
sudo setcap 'cap_net_bind_service=+ep' ./caddy

echo "Caddy installation with Cloudflare DNS provider is complete."
echo "You can now run Caddy with your configuration file using:"
echo "./caddy run --config caddy_config.json"
