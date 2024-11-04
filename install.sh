#!/bin/bash

caddyVersion=2.1.1

echo "Install xcaddy (for building Caddy with custom modules)"
curl -s -O -L https://github.com/caddyserver/xcaddy/releases/download/v0.2.0/xcaddy_0.2.0_linux_amd64.tar.gz
tar xf xcaddy_0.2.0_linux_amd64.tar.gz
rm xcaddy_0.2.0_linux_amd64.tar.gz

echo "Download and build Caddy with Cloudflare DNS provider"
xcaddy build v${caddyVersion} --with github.com/caddy-dns/cloudflare

echo "Move Caddy binary to /usr/local/bin/"

echo "Enable Caddy to bind low ports"
sudo setcap 'cap_net_bind_service=+ep' /usr/local/bin/caddy

echo "Cleanup"
rm -f LICENSE README.md

echo "Caddy installation with Cloudflare DNS provider is complete"
