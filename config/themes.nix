{ nix-colors, ... }:
let
  name = "everforest";
  variant = "dark";
  colorScheme = nix-colors.colorSchemes.${name};

  shellTheme = (nix-colors.lib-contrib { }).shellThemeFromScheme {
    scheme = colorScheme;
  };
in
{
  inherit name variant colorScheme shellTheme;
  palette = colorScheme.palette;

  background = colorScheme.palette.base00;
  backgroundAlt = colorScheme.palette.base01;
  selectionBg = colorScheme.palette.base02;
  comment = colorScheme.palette.base03;
  foregroundAlt = colorScheme.palette.base04;
  foreground = colorScheme.palette.base05;
  foregroundBright = colorScheme.palette.base06;
  backgroundBright = colorScheme.palette.base07;

  red = colorScheme.palette.base08;
  orange = colorScheme.palette.base09;
  yellow = colorScheme.palette.base0A;
  green = colorScheme.palette.base0B;
  cyan = colorScheme.palette.base0C;
  blue = colorScheme.palette.base0D;
  magenta = colorScheme.palette.base0E;
  brown = colorScheme.palette.base0F;

  # Optionally, map ANSI color slots for termaal configs
  ansi = {
    black = colorScheme.palette.base00;
    red = colorScheme.palette.base08;
    green = colorScheme.palette.base0B;
    yellow = colorScheme.palette.base0A;
    blue = colorScheme.palette.base0D;
    magenta = colorScheme.palette.base0E;
    cyan = colorScheme.palette.base0C;
    white = colorScheme.palette.base05;
    brown = colorScheme.palette.base0F;

    brightBlack = colorScheme.palette.base03;
    brightRed = colorScheme.palette.base09;
    brightGreen = colorScheme.palette.base01;
    brightYellow = colorScheme.palette.base0F;
    brightBlue = colorScheme.palette.base06;
    brightMagenta = colorScheme.palette.base0E;
    brightCyan = colorScheme.palette.base04;
    brightWhite = colorScheme.palette.base07;
    brightBrown = colorScheme.palette.base0F;
  };

  systemFont = "Inter";

  # Wallpaper lookup by theme name
  wallpaper =
    let
      wallpaperMap = {
        "catppuccin-frappe" = ./wallpapers/catppuccin/1.jpg;
        "catppuccin-latte" = ./wallpapers/catppuccin/1.jpg;
        "catppuccin-macchiato" = ./wallpapers/catppuccin/1.jpg;
        "catppuccin-mocha" = ./wallpapers/catppuccin/1.jpg;
        "everforest" = ./wallpapers/everforest/1.jpg;
        "gruvbox-dark-hard" = ./wallpapers/gruvbox/1.jpg;
        "gruvbox-dark-medium" = ./wallpapers/gruvbox/1.jpg;
        "gruvbox-dark-soft" = ./wallpapers/gruvbox/1.jpg;
        "gruvbox-light-hard" = ./wallpapers/gruvbox/1.jpg;
        "gruvbox-light-medium" = ./wallpapers/gruvbox/1.jpg;
        "gruvbox-light-soft" = ./wallpapers/gruvbox/1.jpg;
        "kanagawa" = ./wallpapers/kanagawa/1.jpg;
        "nord" = ./wallpapers/nord/1.jpg;
        "tokyo-night-dark" = ./wallpapers/tokyo-night/1.jpg;
        "tokyo-night-light" = ./wallpapers/tokyo-night/2.jpg;
      };
    in
      wallpaperMap.${name} or ./wallpapers/tokyo-night/1.jpg;
}
