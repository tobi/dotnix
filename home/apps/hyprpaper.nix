{ config, ... }:
let
  inherit (config.dotnix) theme;
in
{
  services.hyprpaper = {
    enable = true;

    settings = {
      ipc = "on";
      splash = false;

      preload = [ theme.wallpaperPath ];

      wallpaper = [
        ",${theme.wallpaperPath}"
      ];
    };
  };
}
