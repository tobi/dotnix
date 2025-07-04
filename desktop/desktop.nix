{ config
, lib
, pkgs
, ...
}:

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
    nil
  ];

  programs.vscode.enable = true;
  programs.fuzzel.enable = true;

  # probably should go to home
  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };

  home.sessionVariables = {
    # BROWSER = "google-chrome";
    #    QT_QPA_PLATFORM = "wayland";
    #   ELECTRON_OZONE_PLATFORM_HINT = "auto";
    #   CHROMIUM_FLAGS = "--enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime --wayland-text-input-version=3";
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
      color-scheme = "prefer-dark";
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  services.ollama.enable = true;

  imports = [
    ./modules/waybar
    ./modules/ghostty
    ./modules/alacritty.nix
    ./modules/niri
    ./modules/chatgpt.nix
    ./modules/chromium.nix
    ./modules/google-chrome.nix
    ./modules/cursor
    ./modules/swaylock.nix
    ./modules/steam.nix
  ];
}
