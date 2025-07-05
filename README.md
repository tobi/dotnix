# NixOS Dotfiles & Machine Configuration

A clean, modular NixOS configuration system with cross-platform home-manager dotfiles.

## 🏗️ Architecture

### Directory Structure

```
├── config/              # Global configuration files
│   ├── niri/           # Window manager configuration
│   └── themes.nix      # Centralized theming system
├── desktop/            # Desktop-specific configurations
│   ├── apps/          # Individual application modules
│   └── desktop.nix    # Main desktop configuration
├── home/              # Cross-platform home-manager dotfiles
│   ├── bin/           # Personal scripts and utilities
│   ├── modules/       # Home-manager module definitions
│   └── home.nix       # Core home configuration
├── machines/          # Machine-specific configurations
│   ├── frameling/     # Desktop workstation
│   ├── usb-stick/     # Live USB configuration
│   ├── zerg-wsl2/     # WSL2 configuration
│   └── user.nix       # Centralized user management
├── devshell.nix       # Development environment
└── flake.nix          # Main flake configuration
```

### Key Features

- **Modular Design**: Apps organized in `desktop/apps/` for easy management
- **Centralized Theming**: Single theme configuration in `config/themes.nix`
- **Cross-Platform**: Home-manager configs work on both NixOS and macOS
- **Clean Architecture**: No helper functions, direct nixpkgs.lib.nixosSystem usage
- **Flexible User Management**: Machine-specific user config via `machines/user.nix`

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

1. Create machine directory: `machines/your-machine/`
2. Add `configuration.nix` and `hardware-configuration.nix`
3. Update `flake.nix` with new nixosConfiguration:

```nix
"your-machine" = nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  pkgs = mkPkgs "x86_64-linux";
  specialArgs = {
    inherit inputs theme home-manager niri nix-colors;
    modules-home = [
      ./home/home.nix
      # Add ./desktop/desktop.nix for desktop environments
    ];
  };
  modules = [
    ./machines/your-machine/configuration.nix
    determinate.nixosModules.default
  ];
};
```

## 🏠 Home Configuration

The `home/` directory contains cross-platform dotfiles managed by home-manager:

- **`home.nix`**: Core configuration (shell, git, editor, packages)
- **`modules/`**: Modular configurations (starship, fastfetch, etc.)
- **`bin/`**: Personal scripts and utilities

### Home Modules Pattern

Home modules are specified via the `modules-home` pattern in flake.nix:

```nix
modules-home = [
  ./home/home.nix           # Core configuration
  ./desktop/desktop.nix     # Desktop apps (optional)
];
```

## 🎨 Theming

The theming system is centralized in `config/themes.nix`:

- Based on nix-colors for consistent color schemes
- Currently uses Tokyo Night Dark theme
- Easy to switch themes by modifying the `name` variable

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

1. Create module in `desktop/apps/your-app.nix`
2. Import in `desktop/desktop.nix`
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

- This configuration uses the `modules-home` pattern for clean home-manager integration
- User configuration is centralized in `machines/user.nix`
- Desktop applications are organized in `desktop/apps/` for modularity
- All configurations use the simplified flake architecture without helper functions