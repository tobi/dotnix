# Claude Development Guide

This file provides context and guidelines for Claude when working on this NixOS configuration.

## Current System Configuration

- **Window Manager**: Hyprland (Wayland compositor)
- **Primary Machine**: frameling (Framework Laptop 13.5", AMD Ryzen AI 7 350)
- **Display Setup**: Built-in 2256x1504 @ 1.6x scale + Apple StudioDisplay 5K @ 1.66666x scale
- **Desktop Environment**: Custom Wayland-based setup with Waybar, Hyprland, and GTK/Qt theming

## Architecture Overview

This is a **clean, modern NixOS flake configuration** with clear separation between:
- **Dotfiles** (home-manager/user config) in `home/`
- **System config** (NixOS modules) in `nixos/`
- **Machine definitions** in `hosts/`

### Directory Structure
```
dotnix/
├── flake.nix               # Main NixOS flake
├── flake.lock
│
├── home/                   # Dotfiles / Home-manager (separate flake)
│   ├── flake.nix          # Standalone home-manager flake
│   ├── flake.lock         # Separate lock file
│   ├── home.nix           # Main home configuration
│   ├── paths.nix          # Dotfile redirection (HM → ~/.config/dotnix/)
│   ├── desktop.nix        # Desktop apps entry point
│   ├── shell.nix          # Shell configuration
│   ├── apps/              # Individual app configs
│   │   ├── ghostty.nix
│   │   ├── neovim.nix
│   │   ├── hyprland/      # Hyprland modules (modular structure)
│   │   ├── waybar/
│   │   └── ...
│   ├── theme/             # Theme/colors configuration
│   └── dotnix-options.nix # Home-manager options (hotkeys, etc.)
│
├── nixos/                  # NixOS system modules
│   ├── common.nix         # Shared across all NixOS machines
│   ├── config.nix         # dotnix options definition
│   ├── user.nix           # User management
│   ├── proxmox.nix        # LXC container configuration
│   ├── desktop/           # Desktop environment modules
│   │   ├── default.nix    # Entry point
│   │   ├── hyprland.nix   # Hyprland system config
│   │   ├── audio.nix      # PipeWire configuration
│   │   ├── authentication.nix # 1Password, fingerprint
│   │   └── environment.nix # Desktop env vars
│   └── services/          # Server/service modules (all gated by enable flags)
│       ├── default.nix    # Entry point
│       ├── tailscale.nix  # Tailscale VPN
│       ├── nginx.nix      # Nginx + Tailscale auth
│       ├── forgejo.nix    # Forgejo git server
│       └── warp.nix       # Cloudflare WARP
│
├── hosts/                  # Per-machine configurations
│   ├── frameling/         # Desktop workstation (Framework 13.5")
│   ├── beetralisk/        # Desktop machine
│   ├── zerg-wsl2/         # WSL2 development (no desktop)
│   ├── git/               # Forgejo server (Proxmox LXC)
│   └── usb-stick/         # Live USB/installer
│
├── bin/                    # Utility scripts
│   ├── apply              # Main apply script
│   └── ...
│
├── lib/                    # Helper functions
│   ├── utils.nix          # mkMachines, mkPkgs, etc.
│   └── overlays/
│
└── config/                 # Non-nix config files
    ├── wallpapers/
    ├── secrets/
    └── icons/
```

## Key Patterns

### Two Flakes Architecture
- **Main flake** (`flake.nix`): NixOS system configurations
- **Home flake** (`home/flake.nix`): Standalone home-manager for portability (macOS, WSL, etc.)

### dotnix Options
Configuration uses feature flags in `nixos/config.nix`:
```nix
dotnix = {
  tailnetDomain = "tail250b8.ts.net";  # Global tailnet domain
  home.enable = true;                   # Enables home-manager
  desktop.enable = true;                # Enables desktop environment
  
  services = {
    tailscale.enable = true;            # Tailscale VPN
    nginx.enable = true;                # Nginx with Tailscale auth
    forgejo.enable = true;              # Forgejo git server
    warp.enable = true;                 # Cloudflare WARP
  };
};
```

### Service Module Pattern
Services in `nixos/services/` are all gated by enable flags:
- Import `../../nixos/services` in any host
- Only enabled services are activated
- Services can depend on each other (forgejo requires nginx, nginx requires tailscale)
- Domains auto-derive from `hostname.tailnetDomain` if not specified

### Dotfile Redirection (`home/paths.nix`)
Home-manager does NOT own `~/.zshrc`, `~/.bashrc`, `~/.gitconfig` etc. directly.
Instead, HM writes to `~/.config/dotnix/` and the user's actual dotfiles source/include them:
- `~/.zshrc` → `source ~/.config/dotnix/zshrc`
- `~/.bashrc` → `source ~/.config/dotnix/bashrc`
- `~/.gitconfig` → `[include] path = ~/.config/dotnix/gitconfig`

This lets automated tools (IDE plugins, installers, etc.) safely modify the real dotfiles
without conflicting with read-only nix store symlinks. The `apply` script seeds these
files on first run and warns if the includes are missing.

### Theme System
- `home/theme/default.nix` defines theme options
- Apps access theme via `config.dotnix.theme.palette.base0X`
- Based on nix-colors for consistency

## Common Tasks

### Applying Configuration
```bash
apply                    # Auto-detects context and applies both NixOS + home-manager
apply --help            # Show options
```

### Adding a New Application
1. Create `home/apps/your-app.nix`
2. Add import to `home/desktop.nix`
3. Use `config.dotnix.theme` for styling

### Adding a New Server Service
1. Create `nixos/services/your-service.nix`
2. Add option in `nixos/config.nix` under `dotnix.services`
3. Add import to `nixos/services/default.nix`
4. Gate config with `lib.mkIf cfg.enable { ... }`

### Adding a New Machine
1. Create `hosts/your-machine/default.nix`
2. Import required nixos modules:
   - `../../nixos/common.nix` (always)
   - `../../nixos/user.nix` (always)
   - `../../nixos/desktop` (for desktops)
   - `../../nixos/services` (for servers, or desktops needing services)
3. Set `dotnix` options

### Checking Configuration
```bash
nix flake check --no-build           # Check main flake
cd home && nix flake check --no-build # Check home flake
```

## Important Rules

### What NOT to do:
- Don't put home-manager config inline in flake.nix
- Don't duplicate configuration across machines
- Don't leave commented-out code

### What TO do:
- Use `lib/utils.nix` helper functions
- Use dotnix options for conditional loading
- Keep machine configs focused on hardware/system
- Keep configurations clean and minimal

## Development Commands

```bash
# Apply configuration
apply

# Check flakes
nix flake check --no-build

# Test build without switching
nixos-rebuild build --flake .#frameling

# Enter dev shell
nix develop

# Build ISO
nix build .#nixosConfigurations.usb-stick.config.system.build.isoImage
```

## Example Host Configurations

### Desktop (frameling)
```nix
{
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix
    ../../nixos/common.nix
    ../../nixos/user.nix
    ../../nixos/desktop
    ../../nixos/services
  ];

  dotnix = {
    desktop.enable = true;
    theme = { name = "everforest"; variant = "dark"; };
    services.warp.enable = true;
  };
}
```

### Server (git)
```nix
{
  imports = [
    ./configuration.nix
    ../../nixos/common.nix
    ../../nixos/user.nix
    ../../nixos/proxmox.nix
    ../../nixos/services
  ];

  dotnix = {
    home.enable = false;
    desktop.enable = false;
    services = {
      tailscale = { enable = true; ssh = true; };
      nginx.enable = true;
      forgejo.enable = true;  # Domain auto-derived as git.tail250b8.ts.net
    };
  };
}
```
