{ pkgs, theme, ... }:
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
    xdg-desktop-portal-gtk
  ];

  programs.vscode.enable = true;
  programs.fuzzel.enable = true;

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
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-${theme.variant}";
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-${theme.variant}";
      package = pkgs.gnome-themes-extra;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = theme.variant == "dark";
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = theme.variant == "dark";
    };
  };

  imports = [
    ./apps/waybar
    ./apps/ghostty
    ./apps/alacritty.nix
    ./apps/niri
    ./apps/chatgpt.nix
    ./apps/chromium.nix
    ./apps/google-chrome.nix
    ./apps/cursor
    ./apps/swaylock.nix
    ./apps/steam.nix
    ./apps/mako.nix
  ];
}

