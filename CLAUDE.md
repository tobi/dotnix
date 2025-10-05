# Claude Development Guide

This file provides context and guidelines for Claude when working on this NixOS configuration.

## 🏗️ Architecture Overview

This is a **clean, modern NixOS flake configuration** with the following key principles:

### Design Philosophy
- **Modular organization**: Clean separation of concerns with helper functions for reusability
- **Explicit configuration**: Clear and maintainable patterns
- **Centralized theming**: Single source of truth for colors/themes

### Directory Structure
```
├── bin/                        # Utility scripts (fix-audio, mdget, etc.)
├── config/                     # Global configuration files
│   ├── niri/config.kdl        # Window manager config (referenced globally)
│   ├── secrets/               # Age encrypted secrets
│   └── themes.nix             # Centralized theme system
├── modules/                    # All modular configurations
│   ├── machines/             # Machine-specific configurations
│   │   ├── frameling/        # Desktop workstation
│   │   ├── zerg-wsl2/        # WSL2 development
│   │   └── usb-stick/        # Live USB/installer
│   ├── home-manager/          # Home-manager modules
│   │   ├── apps/             # Individual app modules (alacritty, niri, etc.)
│   │   ├── desktop.nix       # Desktop environment imports
│   │   └── home.nix          # Core home configuration
│   └── nixos/                 # NixOS system modules
│       ├── config.nix        # dotnix options definition
│       ├── niri.nix          # Niri window manager config
│       └── user.nix          # Centralized user management
└── flake.nix                  # Main flake (no lib/common.nix!)
```

## 🔧 Key Patterns

### dotnix Options Pattern
Instead of the complex `modules-home` pattern, we now use NixOS module options:

```nix
"frameling" = nixpkgs.lib.nixosSystem {
  specialArgs = {
    inherit inputs theme home-manager;
  };
  modules = [
    ./modules/machines/frameling/configuration.nix
  ];
};
```

The configuration enables desktop features via:
```nix
dotnix.desktop.enable = true;  # Enables desktop environment
```

### User Management
- `modules/nixos/user.nix` handles user creation + home-manager setup
- Automatically imports appropriate modules based on `dotnix` options
- Machine configurations only need to import `../../nixos/user.nix`

### Theme System
- `config/themes.nix` exports theme with `palette`, `variant`, and `systemFont` attributes
- Desktop apps receive `theme` parameter for styling
- Based on nix-colors for consistency

## 🎨 Code Style Guidelines

### File Organization
- **Imports first**: All imports should be at the top of the file
- **Configuration body**: Main configuration logic in the middle
- **Packages last**: Package lists should be at the end of files
- **Minimal comments**: Remove verbose example comments, keep only essential ones

### Flake Structure
- **Helper functions**: Use utilities like `mkMachines` for cleaner, more maintainable code
- **Clear abstractions**: Reduce boilerplate while keeping configuration readable
- **Consistent patterns**: Standardized machine configuration generation
- **Clear separation**: Each machine gets its own clear configuration block

### Module Patterns
```nix
{ pkgs, theme, ... }:  # Destructure only what's needed
{
  # Configuration settings
  programs.foo = {
    enable = true;
    settings = { ... };
  };
  
  # Package installations at the end
  home.packages = with pkgs; [
    package1
    package2
  ];
}
```

## 🚨 Important Rules

### What NOT to do:
- ❌ Don't put home-manager config inline in flake.nix
- ❌ Don't duplicate user configuration across machines
- ❌ Don't leave commented-out code or verbose example comments

### What TO do:
- ✅ Use helper functions like `mkMachines` to reduce boilerplate
- ✅ Use dotnix options for conditional module loading
- ✅ Keep machine configs focused on hardware/system settings
- ✅ Use centralized modules/nixos/user.nix for user management
- ✅ Organize desktop apps in modules/home-manager/apps/
- ✅ Keep configurations clean and minimal

## 🔍 Common Tasks

### Adding a New Application
1. Create `modules/home-manager/apps/your-app.nix`
2. Add import to `modules/home-manager/desktop.nix`
3. Use `theme` parameter for styling: `{ pkgs, theme, ... }`

### Adding a New Machine
1. Create `modules/machines/your-machine/configuration.nix`
2. Import `../../nixos/user.nix` in the configuration
3. Add machine to flake.nix nixosConfigurations
4. Set `dotnix.desktop.enable = true` if it needs a desktop environment

### Modifying Themes
- Edit `config/themes.nix` to change the theme name
- Theme automatically propagates to all desktop apps
- Apps access colors via `theme.palette.base0X`
- System font available via `theme.systemFont`

## 🛠️ Development Commands

Always run after making changes:
```bash
nix flake check --no-build
```

Other useful commands:
```bash
# Test build without switching
nixos-rebuild build --flake .#frameling

# Enter dev shell
nix develop

# Build ISO
nix build .#nixosConfigurations.usb-stick.config.system.build.isoImage
```

## 📝 File-Specific Notes

### flake.nix
- Uses helper functions from utils/utils.nix for cleaner configuration generation
- Consistent specialArgs pattern across all machines
- Theme configuration loaded once and passed to all machines

### modules/nixos/user.nix
- Handles all user creation and home-manager setup
- Conditionally imports modules based on dotnix options
- Manages desktop-specific environment variables and security settings

### modules/nixos/config.nix
- Defines dotnix.home.enable and dotnix.desktop.enable options
- Central place for configuration feature flags

### modules/home-manager/desktop.nix
- Just imports from apps/ subdirectory
- No complex logic - pure import aggregation

### config/themes.nix
- Returns theme object with palette, variant, and systemFont
- Based on nix-colors color schemes
- Easy to modify by changing the `name` variable

## 🔄 Migration Notes

This configuration recently underwent major restructuring:
- Added helper functions in utils/utils.nix for better maintainability
- Reorganized all modules under modules/ directory
- Replaced modules-home pattern with dotnix options
- Moved utility scripts to top-level bin/ directory
- Centralized NixOS modules in modules/nixos/

The architecture is now more modular and follows clean coding practices.
- to rebuild nixos or reapply home-manager just run "switch". But keep in mind that this requires sudo so likely just ask the user to do it
- use the /nix-check command when you want to see if the config is good
- use the nixos-config-expert agent liberally
- if you changed config.kdl its good to rerun niri validate