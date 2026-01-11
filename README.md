# dotnix

A clean NixOS flake configuration with separate home-manager flake for portability.

## Quick Start

```bash
# Clone
git clone <repo> ~/dotnix
cd ~/dotnix

# Apply configuration (auto-detects NixOS and/or home-manager)
apply

# Deploy to remote host
apply --to git
```

## Structure

```
dotnix/
├── flake.nix               # Main NixOS flake
│
├── home/                   # Home-manager (separate flake)
│   ├── flake.nix          # Standalone for portability (macOS, WSL, etc.)
│   ├── home.nix           # Main home configuration
│   ├── desktop.nix        # Desktop apps entry point
│   ├── shell.nix          # Shell configuration
│   ├── apps/              # Individual app configs
│   └── theme/             # Theme/colors configuration
│
├── nixos/                  # NixOS system modules
│   ├── common.nix         # Shared across all NixOS machines
│   ├── config.nix         # dotnix options definition
│   ├── user.nix           # User management
│   ├── desktop/           # Desktop environment modules
│   └── services/          # Server/service modules
│
├── hosts/                  # Per-machine configurations
│   ├── frameling/         # Framework 13.5" laptop
│   ├── beetralisk/        # Desktop machine
│   ├── zerg-wsl2/         # WSL2 development
│   ├── git/               # Forgejo server (Proxmox LXC)
│   └── usb-stick/         # Live USB/installer
│
├── bin/                    # Utility scripts
│   ├── apply              # Main apply script
│   └── apply-to           # Remote deployment via Colmena
│
├── lib/                    # Helper functions
└── config/                 # Non-nix config files (wallpapers, icons, etc.)
```

## Available Hosts

| Host | Description | Type |
|------|-------------|------|
| `frameling` | Framework 13.5" laptop | Desktop |
| `beetralisk` | Desktop workstation | Desktop |
| `zerg-wsl2` | WSL2 development | Headless |
| `git` | Forgejo server | Server (LXC) |
| `usb-stick` | Live USB/installer | ISO |

## Configuration Options

Configuration uses feature flags via `dotnix` options:

```nix
dotnix = {
  desktop.enable = true;      # Desktop environment (Hyprland)
  home.enable = true;         # Home-manager integration
  
  services = {
    tailscale.enable = true;  # Tailscale VPN
    nginx.enable = true;      # Nginx with Tailscale auth
    forgejo.enable = true;    # Forgejo git server
    warp.enable = true;       # Cloudflare WARP
  };
};
```

## Adding a New Host

1. Create `hosts/your-host/default.nix`
2. Import required modules:
   - `../../nixos/common.nix` (always)
   - `../../nixos/user.nix` (always)
   - `../../nixos/desktop` (for desktops)
   - `../../nixos/services` (for servers)
3. Set `dotnix` options
4. Add to `flake.nix`

## Development

```bash
# Enter dev shell
nix develop

# Check flakes
nix flake check --no-build

# Build without switching
nixos-rebuild build --flake .#frameling

# Build ISO
nix build .#nixosConfigurations.usb-stick.config.system.build.isoImage

# Deploy to remote
apply --to git
apply-to @server  # Deploy to all servers
```
