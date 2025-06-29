{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    swayidle
    swaylock
  ];

  programs.swaylock = {
    enable = true;
    settings = {
      # image = "${config.home.homeDirectory}/Pictures/wallpaper.jpg";
      # color = "00000088"; # semi-transparent black
      # Example of other cool options you can add:
      # font-size = 24;
      # indicator-radius = 100;
      # indicator-thickness = 10;
      show-failed-attempts = true;
      # grace = 2;
      fade-in = 1;
    };
  };

  # Systemd user service to run swayidle for screen locking on idle (niri session)
  # Locks with swaylock after 5 min, suspends (deep sleep) after 15 min
  systemd.user.services.swayidle = {
    Unit = {
      Description = "Idle management daemon for Wayland (locks with swaylock after 5 min, suspends after 15 min)";
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.swayidle}/bin/swayidle -w timeout 300 '${pkgs.swaylock}/bin/swaylock --image ${config.home.homeDirectory}/Pictures/wallpaper.jpg' timeout 900 'systemctl suspend'";
      Restart = "always";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
