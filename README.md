# dotnix

A simple, clean NixOS flake configuration with home-manager.

## Quick Start

```bash
# Clone and enter
git clone <repo> ~/dotnix
cd ~/dotnix

# Apply configuration
sudo nixos-rebuild switch --flake .#frameling
```

## Structure

```
├── modules/        # All modular configurations
│   ├── machines/  # Machine-specific configurations
│   │   ├── frameling/
│   │   ├── zerg-wsl2/
│   │   └── usb-stick/
│   ├── nixos/     # System modules
│   └── home-manager/ # User modules
├── config/         # Global config
└── bin/           # Utility scripts
```

## Available Hosts

- `frameling` - Desktop workstation
- `zerg-wsl2` - WSL2 development
- `usb-stick` - Live USB

## Adding a New Host

1. Create `modules/machines/your-host/configuration.nix`
2. Import `../../modules/nixos/user.nix`
3. Set options like `dotnix.desktop.enable = true`
4. Add to flake.nix

## Development

```bash
# Check config
nix flake check --no-build

# Build ISO
nix build .#nixosConfigurations.usb-stick.config.system.build.isoImage
```