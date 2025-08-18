#!/usr/bin/env bash

echo "Fixing audio and waybar issues..."

# Kill existing services
systemctl --user stop pipewire pipewire-pulse wireplumber
pkill waybar

# Clear pipewire config cache
rm -rf ~/.config/pipewire ~/.local/state/pipewire

# Restart services
sleep 2
systemctl --user start pipewire pipewire-pulse wireplumber

# Wait for services to stabilize
sleep 3

# Restart waybar
waybar &

echo "Services restarted. Please rebuild your system with:"
echo "sudo nixos-rebuild switch --flake .#frameling"
echo ""
echo "The pipewire configuration conflict has been fixed in frameling/configuration.nix"