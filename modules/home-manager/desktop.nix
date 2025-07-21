{ pkgs, theme, ... }:
{

  home.packages = with pkgs; [
    wbg
    libnotify
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
    xdg-desktop-portal-gtk
    playerctl
    spotify-player
  ];

  # probably should go to home
  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };

  services.ollama.enable = true;
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
    reload = "switch";
  };

  # Symlink current theme wallpaper to ~/.config/wallpaper.jpg
  home.file.".config/wallpaper.jpg".source = theme.wallpaper;

  imports = [
    ./apps/waybar.nix
    ./apps/ghostty.nix
    ./apps/alacritty.nix
    ./apps/niri.nix
    ./apps/chatgpt.nix
    ./apps/claude.nix
    ./apps/logseq.nix
    ./apps/chromium.nix
    ./apps/google-chrome.nix
    ./apps/cursor.nix
    ./apps/swaylock.nix
    ./apps/steam.nix
    ./apps/mako.nix
    ./apps/gtk.nix
    ./apps/fuzzel.nix
    ./apps/typora.nix
  ];
}

