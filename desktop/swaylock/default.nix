{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    swaylock
  ];
  programs.swaylock = {
    enable = true;
    settings = {
      image = "${config.home.homeDirectory}/dotnix/desktop/wallpaper.jpg";
      scaling = "fill";
      color = "1a0d2e";
      font = "Inter";
      font-size = 24;
      indicator-radius = 100;
      indicator-thickness = 10;
      show-failed-attempts = true;
      ignore-empty-password = true;
      indicator-caps-lock = true;
      indicator-idle-visible = true;

      # Colors matching the purple/pink wallpaper theme
      bs-hl-color = "ff6b9d";
      caps-lock-bs-hl-color = "ff6b9d";
      caps-lock-key-hl-color = "c77dff";
      inside-color = "666666";
      inside-clear-color = "888888";
      inside-caps-lock-color = "777777";
      inside-ver-color = "555555";
      inside-wrong-color = "ff0000";
      key-hl-color = "c77dff";
      layout-bg-color = "1a0d2e";
      layout-border-color = "c77dff";
      layout-text-color = "333333";
      line-color = "c77dff";
      line-clear-color = "c77dff";
      line-caps-lock-color = "ff6b9d";
      line-ver-color = "c77dff";
      line-wrong-color = "ff0000";
      ring-color = "c77dff";
      ring-clear-color = "c77dff";
      ring-caps-lock-color = "ff6b9d";
      ring-ver-color = "c77dff";
      ring-wrong-color = "ff0000";
      separator-color = "c77dff";
      text-color = "eeeeee";
      text-clear-color = "eeeeee";
      text-caps-lock-color = "eeeeee";
      text-ver-color = "eeeeee";
      text-wrong-color = "ee0000";
    };
  };

  # Use Home Manager's built-in swayidle service instead of manual systemd service
  services.swayidle = {
    enable = true;
    timeouts = [

      {
        timeout = 120; # 2 minutes
        command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
      }
      {
        timeout = 180; # 3 minutes
        command = "${pkgs.swaylock}/bin/swaylock";
      }
      {
        timeout = 600; # 10 minutes
        command = "systemctl suspend";
      }
    ];
  };
}
