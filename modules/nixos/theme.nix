{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.dotnix.theme;
  nix-colors = inputs.nix-colors;

  # Build the theme object based on configuration
  buildTheme = name: systemFont:
    let
      colorScheme = nix-colors.colorSchemes.${name};

      # Derive variant from scheme name/slug
      # Common patterns for dark themes
      darkPatterns = [ "dark" "mocha" "night" "dracula" "gruvbox-dark" "onedark" "solarized-dark" "nord" ];
      nameToCheck = lib.toLower (colorScheme.slug or colorScheme.name or name);
      variant =
        if lib.any (pattern: lib.hasInfix pattern nameToCheck) darkPatterns
        then "dark"
        else "light";

      # Generate wallpaper path based on theme
      wallpaper = "${../..}/config/wallpapers/${name}/1.jpg";
    in
    {
      # Inherit the color scheme object from nix-colors
      inherit colorScheme;
      inherit (colorScheme) palette;
      inherit variant;

      # Additional theme properties
      inherit systemFont wallpaper;

      # Shell theme from nix-colors
      shellTheme = nix-colors.lib.shellThemeFromScheme { scheme = colorScheme; };

      # Named color aliases for easier access
      background = colorScheme.palette.base00;
      backgroundAlt = colorScheme.palette.base01;
      foreground = colorScheme.palette.base05;
      selectionBg = colorScheme.palette.base02;
      selectionFg = colorScheme.palette.base06;

      # Standard terminal colors
      black = colorScheme.palette.base00;
      red = colorScheme.palette.base08;
      green = colorScheme.palette.base0B;
      yellow = colorScheme.palette.base0A;
      blue = colorScheme.palette.base0D;
      magenta = colorScheme.palette.base0E;
      cyan = colorScheme.palette.base0C;
      white = colorScheme.palette.base05;
      orange = colorScheme.palette.base09;

      # Bright variants
      brightBlack = colorScheme.palette.base03;
      brightRed = colorScheme.palette.base08;
      brightGreen = colorScheme.palette.base0B;
      brightYellow = colorScheme.palette.base0A;
      brightBlue = colorScheme.palette.base0D;
      brightMagenta = colorScheme.palette.base0E;
      brightCyan = colorScheme.palette.base0C;
      brightWhite = colorScheme.palette.base07;

      # ANSI color mappings for compatibility
      ansi = {
        black = colorScheme.palette.base00;
        red = colorScheme.palette.base08;
        green = colorScheme.palette.base0B;
        yellow = colorScheme.palette.base0A;
        blue = colorScheme.palette.base0D;
        magenta = colorScheme.palette.base0E;
        cyan = colorScheme.palette.base0C;
        white = colorScheme.palette.base05;
        brightBlack = colorScheme.palette.base03;
        brightRed = colorScheme.palette.base08;
        brightGreen = colorScheme.palette.base0B;
        brightYellow = colorScheme.palette.base0A;
        brightBlue = colorScheme.palette.base0D;
        brightMagenta = colorScheme.palette.base0E;
        brightCyan = colorScheme.palette.base0C;
        brightWhite = colorScheme.palette.base07;
      };
    };
in
{
  options.dotnix.theme = lib.mkOption {
    type = lib.types.attrs;
    default = buildTheme "catppuccin-mocha" "Inter";
    description = "The complete theme configuration object";
    internal = true;
  };

  options.dotnix.themeName = lib.mkOption {
    type = lib.types.str;
    default = "catppuccin-mocha";
    description = "The nix-colors color scheme name to use";
    example = "nord";
  };

  options.dotnix.themeFont = lib.mkOption {
    type = lib.types.str;
    default = "Inter";
    description = "The system font to use";
    example = "Roboto";
  };

  config = {
    # Build the theme object based on the configuration options
    dotnix.theme = lib.mkOverride 900 (buildTheme config.dotnix.themeName config.dotnix.themeFont);
  };
}

