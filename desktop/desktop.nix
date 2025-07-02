{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    wbg
    mako
    rustdesk
    gcr
    gnome-themes-extra
    gnome-keyring
    libsecret
    wev
    unzip
    zsync
    dropbox-cli
    blueberry
    pavucontrol
    pamixer
    brightnessctl
    dex
    wine
    gnupg
    # ruby_3_4
    # nodejs_22
    # python313
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
    PATH = "$PATH:~/.gem/ruby/3.4.0/bin:";
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

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "Adwaita-dark";
      color-scheme = "prefer-dark";
    };
  };

  services.ollama.enable = true;

  imports = [
    ./waybar
    ./ghostty
    ./niri
    ./chatgpt
    ./chromium
    ./google-chrome
    ./Cursor
    ./swaylock
    ./Steam
  ];
}
