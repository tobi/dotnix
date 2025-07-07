# NixOS Dotfiles & Machine Configuration

A clean, modular NixOS configuration system with cross-platform home-manager dotfiles.

## 🏗️ Architecture

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
│       ├── dot.nix           # dotnix options definition
│       ├── niri.nix          # Niri window manager config
│       └── user.nix          # Centralized user management
├── devshell.nix               # Development environment
└── flake.nix                  # Main flake configuration
```

### Key Features

- **Modular Design**: All modules organized under `modules/` directory
- **Centralized Theming**: Single theme configuration in `config/themes.nix`
- **Cross-Platform**: Home-manager configs work on both NixOS and macOS
- **Clean Architecture**: No helper functions, direct nixpkgs.lib.nixosSystem usage
- **Flexible Configuration**: Use `dotnix` options to enable/disable features

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
5. Update `flake.nix` with new nixosConfiguration:

```nix
"your-machine" = nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  pkgs = mkPkgs "x86_64-linux";
  specialArgs = {
    inherit inputs theme home-manager;
  };
  modules = [
    ./modules/machines/your-machine/configuration.nix
  ];
};
```

## 🏠 Home Configuration

The `modules/home-manager/` directory contains cross-platform dotfiles:

- **`home.nix`**: Core configuration (shell, git, editor, packages)
- **`desktop.nix`**: Desktop environment configuration
- **`apps/`**: Individual application modules (alacritty, ghostty, etc.)

### Configuration Pattern

Home modules are automatically loaded based on `dotnix` options:

```nix
# In your machine configuration:
dotnix.desktop.enable = true;  # Loads desktop environment
dotnix.home.enable = true;     # Loads base home configuration (default)
```

## 🎨 Theming

The theming system is centralized in `config/themes.nix`:

- Based on nix-colors for consistent color schemes
- Currently uses Tokyo Night Dark theme
- Easy to switch themes by modifying the `name` variable
- Provides `palette`, `variant`, and `systemFont` attributes

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

## 📦 Build Outputs

- **NixOS ISO**: `nix build .#nixosConfigurations.usb-stick.config.system.build.isoImage`
- **Development Shell**: `nix develop`
- **Home Configuration**: Available for any system with home-manager

## 🔧 Troubleshooting

- **Flake check fails**: Run `nix flake check --no-build` to validate configuration
- **Build errors**: Check that all imports exist and syntax is correct
- **Home-manager conflicts**: Ensure no duplicate module imports
- **Theme issues**: Verify theme configuration in `config/themes.nix`

## 📝 Notes

- This configuration uses NixOS module options for clean conditional loading
- User configuration is centralized in `modules/nixos/user.nix`
- All modules are organized under `modules/` for clear separation
- Utility scripts are available in the top-level `bin/` directory
- All configurations use the simplified flake architecture without helper functions