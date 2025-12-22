{ config, lib, ... }:
let
  theme = config.dotnix.theme;
in
{
  config = lib.mkIf (config.dotnix.wm == "hyprland") {
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
  };
}
