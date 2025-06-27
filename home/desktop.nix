{ config, lib, pkgs, ... }:
let
  isLinux = pkgs.stdenv.isLinux;
in
{

   # Hyprland configuration
  # wayland.windowManager.hyprland = {
  #   enable = true;
  #   extraConfig = builtins.readFile ./config/hyprland.conf;
  # };

  # wayland.windowManager.niri = {
  #   enable = true;
  # };

  # programs.niri.enable = true;
  programs.vscode.enable = true;

  # wayland.windowManager.niri = {
  #    enable = true;
  # #   extraConfig = builtins.readFile ./config/hyprland.conf;
  #  };

  # XDG configuration for proper application launching
  xdg = lib.mkIf isLinux {
    enable = true;
    configFile."hypr/hyprland.conf".source = ./config/hyprland.conf;
    
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
