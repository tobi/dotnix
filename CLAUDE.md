# Claude Development Guide

This file provides context and guidelines for Claude when working on this NixOS configuration.

## 🖥️ Current System Configuration

- **Window Manager**: Hyprland (Wayland compositor)
- **Primary Machine**: frameling (Framework Laptop 13.5", AMD Ryzen AI 7 350)
- **Display Setup**: Built-in 2256x1504 @ 1.6x scale + Apple StudioDisplay 5K @ 1.66666x scale
- **Desktop Environment**: Custom Wayland-based setup with Waybar, Hyprland, and GTK/Qt theming

**Note**: While Niri configurations still exist in the codebase (`modules/nixos/niri.nix`, `modules/home-manager/apps/niri/`), the system is currently running **Hyprland** as the active window manager.

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
│   ├── secrets/               # Age encrypted secrets
│   └── themes.nix             # Centralized theme system
├── modules/                    # All modular configurations
│   ├── machines/             # Machine-specific configurations
│   │   ├── frameling/        # Desktop workstation (Framework 13.5")
│   │   ├── beetralisk/       # Desktop machine
│   │   ├── zerg-wsl2/        # WSL2 development
│   │   └── usb-stick/        # Live USB/installer
│   ├── home-manager/          # Home-manager modules
│   │   ├── apps/             # Individual app modules (30+ apps)
│   │   │   ├── hyprland/     # Hyprland WM config (modular structure)
│   │   │   │   ├── envs.nix     # Environment variables
│   │   │   │   ├── input.nix    # Input devices (keyboard, mouse, touchpad)
│   │   │   │   ├── outputs.nix  # Monitor configuration
│   │   │   │   ├── layout.nix   # Gaps, borders, animations
│   │   │   │   ├── binds.nix    # Keybindings
│   │   │   │   ├── startup.nix  # Autostart programs
│   │   │   │   └── window-rules.nix # Window and layer rules
│   │   │   ├── waybar/       # Waybar config (modular structure)
│   │   │   └── [other apps]  # alacritty, chrome, firefox, etc.
│   │   ├── desktop.nix       # Desktop environment imports
│   │   └── home.nix          # Core home configuration
│   └── nixos/                 # NixOS system modules
│       ├── audio.nix         # Audio configuration
│       ├── authentication.nix # Authentication services
│       ├── common.nix        # Common system settings
│       ├── config.nix        # dotnix options definition
│       ├── environment.nix   # System environment variables
│       ├── hyprland.nix      # Hyprland system integration
│       ├── niri.nix          # Niri window manager (legacy)
│       ├── theme.nix         # System theming
│       ├── user.nix          # Centralized user management
│       ├── warp.nix          # Warp terminal integration
│       └── wm.nix            # Window manager abstractions
└── flake.nix                  # Main flake entry point
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
4. For complex apps, create a subdirectory like `apps/your-app/` with modular config files

### Modifying Hyprland Configuration
Hyprland config is split into logical modules under `modules/home-manager/apps/hyprland/`:
- **envs.nix** - Environment variables (GDK_SCALE, QT settings, etc.)
- **input.nix** - Keyboard, mouse, touchpad configuration
- **outputs.nix** - Monitor configuration and scaling
- **layout.nix** - Gaps, borders, animations, decorations
- **binds.nix** - Keybindings
- **startup.nix** - Autostart programs
- **window-rules.nix** - Window and layer rules

After changes, test with: `hyprctl reload` or restart Hyprland

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

### modules/nixos/hyprland.nix
- System-level Hyprland integration
- Enables Hyprland as the default session
- Sets up necessary system services and security policies

### modules/nixos/wm.nix
- Window manager abstractions
- Common settings shared across different WM implementations

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

## 🔍 Searching the Codebase

### Using ast-grep for Structural Code Search

`ast-grep` is a powerful AST-based search tool that understands Nix syntax. It's significantly more powerful than `rg` for finding structural patterns because it matches on the parse tree, not just text.

**When to use ast-grep vs ripgrep:**
- Use `ast-grep` when searching for **structural patterns** (attribute paths, function calls, specific language constructs)
- Use `rg` when searching for **text patterns** (strings, comments, variable names as text)

**Key ast-grep patterns for this codebase:**

```bash
# Find all theme customizations (attribute path with metavariable)
ast-grep -p 'theme.$FIELD' -l nix
# Returns: theme.palette, theme.wallpaperPath, theme.systemFont, etc.

# Find all config.dotnix references
ast-grep -p 'config.dotnix.$FIELD' -l nix
# Returns: config.dotnix.desktop.enable, config.dotnix.theme, etc.

# Find all palette color uses
ast-grep -p 'palette.$COLOR' -l nix
# Returns: palette.base00, palette.base0D, etc.

# Find all flake input references
ast-grep -p 'inputs.$INPUT' -l nix
# Returns: inputs.niri.overlays.niri, inputs.home-manager, etc.

# Find conditional configurations
ast-grep -p 'lib.mkIf $COND $VAL' -l nix
# Returns all conditional module options

# Find default value declarations
ast-grep -p 'lib.mkDefault $VAL' -l nix

# Find with pkgs expressions
ast-grep -p 'with pkgs; $BODY' -l nix
```

**Important notes:**
- `ast-grep` defaults to searching the current directory recursively - no need to specify paths
- Metavariables like `$FIELD`, `$VAL`, `$COND` capture any matching AST node
- String literals need quotes: `'"$STRING"'` to match all strings
- Does NOT work for: multi-level metavariables (`$OBJ.$FIELD.enable`), assignment patterns (`enable = $VAL`), or complex let expressions

**Common use cases:**
```bash
# Refactoring: Find all uses of a config option
ast-grep -p 'config.dotnix.desktop.enable' -l nix

# Understanding: See all theme attribute accesses
ast-grep -p 'theme.$FIELD' -l nix | wc -l  # Count: 76 locations

# Code review: Find all conditional desktop configurations
ast-grep -p 'lib.mkIf config.dotnix.desktop.enable $VAL' -l nix
```

## 🔧 Development Commands

- To rebuild nixos or reapply home-manager just run `switch`. This requires sudo so ask the user to do it
- Use the `/nix-check` command when you want to see if the config is good
- Use the `nix-config-expert` agent liberally for NixOS-specific questions
- For desktop, we exclusively use **Wayland** with **Hyprland** as the window manager
- Hyprland commands: `hyprctl monitors`, `hyprctl clients`, `hyprctl dispatch`, etc.
- Check Hyprland config: Review `modules/home-manager/apps/hyprland/` subdirectories