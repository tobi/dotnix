# Theme Module Migration Summary

## What Changed

The theme configuration has been transformed from a simple imported file to a proper NixOS module. This migration brings the theme system in line with NixOS best practices and makes it configurable per-machine.

### Key Changes:

1. **New Theme Module** (`modules/nixos/theme.nix`):
   - Provides theme configuration through `config.dotnix.theme`
   - Configurable options: `dotnix.themeName` and `dotnix.themeFont`
   - Derives variant ("dark"/"light") from theme name
   - Provides all the same attributes as before

2. **Removed Files**:
   - `config/themes.nix` - logic moved into the module

3. **Updated Files**:
   - `modules/nixos/dot.nix` - now imports theme module
   - `modules/nixos/user.nix` - passes `config.dotnix.theme` to home-manager
   - `flake.nix` - removed theme import
   - `utils.nix` - removed theme parameter
   - All machine configurations - removed theme parameter

### Usage

To customize theme per machine:
```nix
{
  dotnix.themeName = "nord";        # default: "catppuccin-mocha"
  dotnix.themeFont = "Roboto";      # default: "Inter"
}
```

The theme is available as:
- `config.dotnix.theme` in NixOS modules
- `theme` in home-manager modules (unchanged)

### Theme Attributes

The theme object provides:
- `colorScheme` - Full nix-colors scheme
- `palette` - Base16 colors (base00-base0F)
- `variant` - "dark" or "light"
- `systemFont` - Configured font
- `wallpaper` - Theme-specific wallpaper
- `shellTheme` - Shell color configuration
- Named colors: `background`, `backgroundAlt`, `foreground`, `selectionBg`, `selectionFg`
- Terminal colors: `black`, `red`, `green`, `yellow`, `blue`, `magenta`, `cyan`, `white`, `orange`
- Bright variants: `brightBlack`, `brightRed`, etc.
- ANSI mappings: `ansi.black`, `ansi.red`, etc.