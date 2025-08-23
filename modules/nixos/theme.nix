{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.dotnix.theme;
  nix-colors = inputs.nix-colors;
in
{
  options.dotnix.theme = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "catppuccin-mocha";
      description = "The nix-colors color scheme name to use";
      example = "everforest";
    };

    font = lib.mkOption {
      type = lib.types.str;
      default = "Inter";
      description = "The system font to use";
      example = "Roboto";
    };

    variant = lib.mkOption {
      type = lib.types.enum [ "dark" "light" ];
      default = "light";
      description = "The variant of the theme to use";
      example = "dark";
    };

    wallpaper = lib.mkOption {
      type = lib.types.str;
      default = "1.jpg"; # Most themes have this as the default
      description = "The wallpaper to use";
      example = "wallpaper.jpg";
    };

    # Computed theme values
    colorScheme = lib.mkOption {
      type = lib.types.attrs;
      readOnly = true;
      description = "The computed color scheme from nix-colors";
    };

    palette = lib.mkOption {
      type = lib.types.attrs;
      readOnly = true;
      description = "The color palette from the scheme";
    };

    systemFont = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      description = "The system font (alias for font)";
    };

    # Named color aliases
    background = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      description = "Background color";
    };

    backgroundAlt = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      description = "Alternative background color";
    };

    foreground = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      description = "Foreground/text color";
    };

    # Terminal colors
    black = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      description = "Black color";
    };

    red = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      description = "Red color";
    };

    green = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      description = "Green color";
    };

    yellow = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      description = "Yellow color";
    };

    blue = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      description = "Blue color";
    };

    magenta = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      description = "Magenta color";
    };

    cyan = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      description = "Cyan color";
    };

    white = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      description = "White color";
    };

    orange = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      description = "Orange color";
    };

    selectionBg = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      description = "Selection background color";
    };

    selectionFg = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      description = "Selection foreground color";
    };

    wallpaperPath = lib.mkOption {
      type = lib.types.path;
      readOnly = true;
      description = "Full path to the wallpaper file";
    };

    ansi = lib.mkOption {
      type = lib.types.attrs;
      readOnly = true;
      description = "ANSI color mappings including bright colors";
    };
  };

  config =
    let
      colorScheme = nix-colors.colorSchemes.${cfg.name};
    in
    {
      dotnix.theme = {
        colorScheme = colorScheme;
        palette = colorScheme.palette;
        systemFont = cfg.font;

        # Named color aliases
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

        # Wallpaper path
        wallpaperPath = "${./../..}/config/wallpapers/${cfg.name}/${cfg.wallpaper}";

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
