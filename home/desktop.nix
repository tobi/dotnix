{ config, lib, pkgs, ... }:
let
  isLinux = pkgs.stdenv.isLinux;
in
{

  home.packages = with pkgs; [
    wbg
    mako
    rustdesk
    gcr
    gnome-keyring
    libsecret
  ];

  # programs.niri.enable = true;
  programs.vscode.enable = true;
  programs.firefox.enable = true;
  programs.fuzzel.enable = true;
  programs.yazi.enable = true;
  programs.swaylock.enable = true;

  # programs.ruskdesk.enable = true;
  # programs.mako.enable = true;

  programs.waybar.settings = {
    enable = true;
    mainBar.style = builtins.readFile ./config/waybar.css;
    mainBar.layer = "top";
  };

  #   programs.waybar.settings = [
  #   {
  #     layer = "top";
  #     position = "top";
  #     height = 30;
  #     output = [ "eDP-1" "HDMI-A-1" ];
  #     modules-left = [ "sway/workspaces" "sway/mode" "wlr/taskbar" ];
  #     modules-center = [ "sway/window" "custom/hello-from-waybar" ];
  #     modules-right = [ "mpd" "custom/mymodule#with-css-id" "temperature" ];
  #   }
  # ];

  services.gnome-keyring.enable = true;

  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };

  # XDG configuration for proper application launching
  xdg = lib.mkIf isLinux {
    enable = true;

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
