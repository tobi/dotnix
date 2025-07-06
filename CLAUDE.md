# Claude Development Guide

This file provides context and guidelines for Claude when working on this NixOS configuration.

## 🏗️ Architecture Overview

This is a **clean, modern NixOS flake configuration** with the following key principles:

### Design Philosophy
- **No helper functions**: Direct use of `nixpkgs.lib.nixosSystem` for clarity
- **Explicit over implicit**: All configuration is visible in flake.nix
- **Modular organization**: Clean separation of concerns
- **Centralized theming**: Single source of truth for colors/themes

### Directory Structure
```
├── config/              # Global configuration files
│   ├── niri/config.kdl # Window manager config (referenced globally)
│   └── themes.nix      # Centralized theme system
├── desktop/            # Desktop environment
│   ├── apps/          # Individual app modules (alacritty, niri, etc.)
│   └── desktop.nix    # Main desktop imports
├── home/              # Cross-platform dotfiles
│   └── home.nix       # Core home-manager config
├── machines/          # Machine-specific configurations
│   ├── frameling/     # Desktop workstation
│   ├── zerg-wsl2/     # WSL2 development
│   ├── usb-stick/     # Live USB/installer
│   └── user.nix       # Centralized user management
└── flake.nix          # Main flake (no lib/common.nix!)
```

## 🔧 Key Patterns

### modules-home Pattern
The `modules-home` attribute in specialArgs defines which home-manager modules to load:

```nix
"frameling" = nixpkgs.lib.nixosSystem {
  specialArgs = {
    inherit inputs theme home-manager niri nix-colors;
    modules-home = [
      ./home/home.nix           # Always included
      ./desktop/desktop.nix     # Desktop environments only
    ];
  };
  modules = [
    ./machines/frameling/configuration.nix
    determinate.nixosModules.default
  ];
};
```

### User Management
- `machines/user.nix` handles user creation + home-manager setup
- Imported by each machine's configuration.nix
- Machine-specific user settings (groups, SSH keys) added in machine configs

### Theme System
- `config/themes.nix` exports theme with `palette` and `variant` attributes
- Desktop apps receive `theme` parameter for styling
- Based on nix-colors for consistency

## 🎨 Code Style Guidelines

### File Organization
- **Imports first**: All imports should be at the top of the file
- **Configuration body**: Main configuration logic in the middle
- **Packages last**: Package lists should be at the end of files
- **Minimal comments**: Remove verbose example comments, keep only essential ones

### Flake Structure
- **Simple inputs**: Pass inputs directly from flake to modules via specialArgs
- **No abstractions**: Keep flake.nix explicit and readable
- **Direct nixosSystem calls**: No wrapper functions or lib helpers
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
- ❌ Don't create helper functions in lib/
- ❌ Don't use mkNixosSystem or similar abstractions
- ❌ Don't put home-manager config inline in flake.nix
- ❌ Don't duplicate user configuration across machines
- ❌ Don't leave commented-out code or verbose example comments

### What TO do:
- ✅ Use direct `nixpkgs.lib.nixosSystem` calls
- ✅ Pass modules-home via specialArgs
- ✅ Keep machine configs focused on hardware/system settings
- ✅ Use centralized user.nix for user management
- ✅ Organize desktop apps in desktop/apps/
- ✅ Keep configurations clean and minimal

## 🔍 Common Tasks

### Adding a New Application
1. Create `desktop/apps/your-app.nix`
2. Add import to `desktop/desktop.nix`
3. Use `theme` parameter for styling: `{ pkgs, theme, ... }`

### Adding a New Machine
1. Create `machines/your-machine/configuration.nix`
2. Import `../user.nix` in the configuration
3. Add machine to flake.nix nixosConfigurations
4. Set appropriate `modules-home` list

### Modifying Themes
- Edit `config/themes.nix` to change the theme name
- Theme automatically propagates to all desktop apps
- Apps access colors via `theme.palette.base0X`

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
- Contains all nixosConfigurations directly (no lib imports)
- Each machine specifies its own modules-home list
- Theme configuration loaded once and passed to all machines

### machines/user.nix
- Handles all user creation and home-manager setup
- Reads modules-home from specialArgs
- Conditionally loads niri modules for desktop environments

### desktop/desktop.nix
- Just imports from desktop/apps/
- No complex logic - pure import aggregation

### config/themes.nix
- Returns theme object with palette and variant
- Based on nix-colors color schemes
- Easy to modify by changing the `name` variable

## 🔄 Migration Notes

This configuration recently underwent major simplification:
- Removed lib/common.nix and all helper functions
- Moved from desktop/modules/ to desktop/apps/
- Implemented modules-home pattern
- Centralized user management in machines/user.nix

The architecture is now much cleaner and more explicit.