{ config, lib, pkgs, ... }:
let
  isLinux = pkgs.stdenv.isLinux;
in
{

   # Hyprland configuration
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ./hyprland.conf;
  };

  

  # Kanshi for automatic monitor configuration
  services.kanshi = lib.mkIf isLinux {
    enable = true;
    profiles = {
      single = {
        outputs = [
          {
            criteria = "*";
            status = "enable";
          }
        ];
      };
      dual = {
        outputs = [
          {
            criteria = "DP-1";
            status = "enable";
            mode = "2560x1440@144Hz";
            position = "0,0";
          }
          {
            criteria = "DP-2";
            status = "enable";
            mode = "3840x1260@240Hz";
            position = "2560,0";
          }
        ];
      };
    };
  };

  # XDG configuration for proper application launching
  xdg = lib.mkIf isLinux {
    enable = true;
    configFile."hypr/hyprland.conf".source = ./hyprland.conf;
    
    # Set default applications
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "chromium-browser.desktop";
        "x-scheme-handler/http" = "chromium-browser.desktop";
        "x-scheme-handler/https" = "chromium-browser.desktop";
        "x-scheme-handler/about" = "chromium-browser.desktop";
        "x-scheme-handler/unknown" = "chromium-browser.desktop";
      };
    };
  };
}