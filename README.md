# NixOS Dotfiles & Machine Configuration

A clean, modern NixOS flake configuration with cross-platform home-manager dotfiles, designed for simplicity and modularity.

## 🏗️ Architecture

This configuration follows a **clean architecture** with modular patterns and helpful abstractions. Built around three core principles:

1. **Clear abstractions**: Helper functions reduce boilerplate while maintaining readability
2. **Modular organization**: Clean separation between system, home, and machine configs
3. **Centralized theming**: Single source of truth for colors and fonts

### How It Works

The system uses **dotnix options** to conditionally load modules:

```nix
# In your machine configuration:
dotnix.desktop.enable = true;  # Loads desktop environment
dotnix.home.enable = true;     # Loads base home configuration (default)
```

This triggers the centralized user management system (`modules/nixos/user.nix`) to automatically import the appropriate home-manager modules based on what features are enabled.

### Directory Structure

```
├── bin/                        # Utility scripts (fix-audio, mdget, etc.)
├── config/                     # Global configuration files
│   ├── niri/                  # Window manager configuration
│   ├── secrets/               # Age encrypted secrets
│   └── themes.nix             # Centralized theming system
├── modules/                    # All modular configurations
│   ├── home-manager/          # Home-manager modules
│   │   ├── apps/             # Individual application modules
│   │   ├── desktop.nix       # Desktop environment imports
│   │   └── home.nix          # Core home configuration
│   ├── machines/              # Machine-specific configurations
│   │   ├── frameling/        # Desktop workstation
│   │   ├── usb-stick/        # Live USB configuration
│   │   └── zerg-wsl2/        # WSL2 configuration
│   └── nixos/                 # NixOS system modules
│       ├── config.nix        # dotnix options definition
│       ├── niri.nix          # Niri window manager config
│       └── user.nix          # Centralized user management
├── devshell.nix               # Development environment
└── flake.nix                  # Main flake configuration
```

### Key Features

- **Helper Functions**: Use utilities like `mkMachines` to reduce boilerplate and improve maintainability
- **Modular Design**: All modules organized under `modules/` directory
- **Centralized User Management**: Single `modules/nixos/user.nix` handles all user setup
- **dotnix Options Pattern**: Clean conditional loading with simple abstractions
- **Centralized Theming**: Single theme configuration in `config/themes.nix`
- **Cross-Platform**: Home-manager configs work on both NixOS and macOS

## 🚀 Quick Start

### Prerequisites
- Nix with flakes enabled
- Git

### Setup

1. **Clone the repository**:
   ```bash
   git clone <repository-url> ~/dotnix
   cd ~/dotnix
   ```

2. **Enter development shell**:
   ```bash
   nix develop
   # or with older nix:
   NIX_CONFIG="experimental-features = nix-command flakes" nix develop
   ```

3. **Apply configurations**:
   ```bash
   # For NixOS systems (replace 'frameling' with your hostname)
   sudo nixos-rebuild switch --flake .#frameling
   
   # For home-manager only (macOS/other Linux)
   home-manager switch --flake .#tobi
   ```

## 🖥️ Machine Configurations

### Available Machines

- **`frameling`**: Main desktop workstation with full desktop environment
- **`zerg-wsl2`**: WSL2 configuration with essential tools
- **`usb-stick`**: Live USB/installer image with desktop environment

### Adding a New Machine

1. Create machine directory: `modules/machines/your-machine/`
2. Add `configuration.nix` and `hardware-configuration.nix`
3. Import `../../nixos/user.nix` in your configuration.nix
4. Set `dotnix.desktop.enable = true` if you want a desktop environment
5. The machine will be automatically detected by the `mkMachines` utility function

## 🏠 Home Configuration

The `modules/home-manager/` directory contains cross-platform dotfiles that work on both NixOS and macOS:

- **`home.nix`**: Core configuration (shell, git, editor, packages)
- **`desktop.nix`**: Desktop environment configuration (pure import aggregation)
- **`apps/`**: Individual application modules (alacritty, ghostty, etc.)

### How User Management Works

Instead of complex abstractions, this system uses a centralized approach:

1. **`modules/nixos/user.nix`**: Handles user creation + home-manager setup
2. **Automatic imports**: Based on `dotnix` options, imports appropriate modules
3. **Simple pattern**: Machine configs only need `import ../../nixos/user.nix`

```nix
# In your machine configuration:
dotnix.desktop.enable = true;  # Loads desktop environment
dotnix.home.enable = true;     # Loads base home configuration (default)
```

This automatically loads the right modules without duplication across machines.

## 🎨 Theming

The theming system is centralized in `config/themes.nix`:

- Based on nix-colors for consistent color schemes
- Currently uses Tokyo Night Dark theme
- Easy to switch themes by modifying the `name` variable
- Provides `palette`, `variant`, and `systemFont` attributes
- Desktop apps automatically receive `theme` parameter for styling
- Theme propagates to all modules without manual configuration

## 🛠️ Development

### Available Commands

```bash
# Verify configuration
nix flake check --no-build

# Build without switching
nixos-rebuild build --flake .#frameling

# Test configuration in VM
nixos-rebuild build-vm --flake .#frameling
```

### Adding Applications

1. Create module in `modules/home-manager/apps/your-app.nix`
2. Import in `modules/home-manager/desktop.nix`
3. Applications automatically receive `theme` parameter for styling

### Code Style Guidelines

- **Imports first**: All imports at the top of files
- **Configuration body**: Main logic in the middle
- **Packages last**: Package lists at the end
- **Minimal comments**: Remove verbose examples, keep essentials only

## 📦 Build Outputs

- **NixOS ISO**: `nix build .#nixosConfigurations.usb-stick.config.system.build.isoImage`
- **Development Shell**: `nix develop`
- **Home Configuration**: Available for any system with home-manager

## 🔧 Troubleshooting

- **Flake check fails**: Run `nix flake check --no-build` to validate configuration
- **Build errors**: Check that all imports exist and syntax is correct
- **Home-manager conflicts**: Ensure no duplicate module imports
- **Theme issues**: Verify theme configuration in `config/themes.nix`

## 📝 Design Philosophy

This configuration recently underwent major restructuring to achieve:

### What We Avoid
- ❌ Inline home-manager config in flake.nix
- ❌ Duplicated user configuration across machines
- ❌ Commented-out code or verbose examples

### What We Use Instead
- ✅ Helper functions like `mkMachines` for cleaner code
- ✅ dotnix options for conditional module loading
- ✅ Centralized `modules/nixos/user.nix` for user management
- ✅ Clean module organization under `modules/` directory
- ✅ Maintainable configuration patterns with good abstractions

This creates a maintainable, understandable system that follows NixOS conventions with helpful abstractions that reduce complexity.