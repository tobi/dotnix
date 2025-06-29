{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    wbg
    mako
    rustdesk
    gcr
    gnome-keyring
    libsecret
    wev
    zsync
    dropbox-cli
    blueberry
    pavucontrol
    pamixer
    brightnessctl
    dex
  ];

  programs.vscode.enable = true;
  programs.fuzzel.enable = true;
  programs.spotify-player.enable = true;

  # probably should go to home
  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };

  home.sessionVariables = {
    BROWSER = "google-chrome";
    QT_QPA_PLATFORM = "wayland";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    CHROMIUM_FLAGS = "--enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime --wayland-text-input-version=3";
  };

  services.gnome-keyring.enable = true;

  # XDG configuration for proper application launching
  xdg = {
    enable = true;
    portal.xdgOpenUsePortal = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/http" = "google-chrome.desktop";
        "x-scheme-handler/https" = "google-chrome.desktop";
      };
    };
  };


  home.shellAliases = {
    switch = "sudo nixos-rebuild switch --flake ~/dotnix && source ~/.zshrc";
  };

  imports = [
    ./waybar
    ./ghostty
    ./niri
    ./chatgpt
    ./chromium
    ./google-chrome
    ./Cursor
    ./swaylock
  ];
}
