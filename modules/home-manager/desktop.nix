{ pkgs, theme, ... }:
{

  home.packages = with pkgs; [
    # Desktop environment and window management
    wbg # Wallpaper setter for Wayland
    xdg-desktop-portal-gtk # XDG desktop portal for GTK applications
    wtype # Wayland typing simulation for clipboard shortcuts

    # Audio control
    pavucontrol # PulseAudio volume control GUI
    pamixer # PulseAudio command-line mixer
    playerctl # Media player controller
    spotify-player # Spotify TUI client

    # System utilities
    brightnessctl # Screen brightness control
    blueberry # Bluetooth manager
    dex # Desktop entry execution
    libnotify # Desktop notifications library
    wev # Wayland event viewer

    # Security and authentication
    gcr # GNOME crypto services
    gnome-keyring # GNOME keyring daemon
    gnupg # GNU Privacy Guard
    libsecret # Secret service library

    # File operations and compression
    dropbox-cli # Dropbox command-line interface

    # Applications
    rustdesk # Remote desktop client
    wine # Windows compatibility layer
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
        "x-scheme-handler/http" = "google-chrome-shopify.desktop";
        "x-scheme-handler/https" = "google-chrome-shopify.desktop";
        "inode/directory" = "org.gnome.Nautilus.desktop";
      };
    };
  };

  # Symlink current theme wallpaper to ~/.config/wallpaper.jpg
  home.file.".config/wallpaper.jpg".source = theme.wallpaperPath;

  imports = [
    ./dotnix-options.nix
    ./apps/waybar.nix
    ./apps/ghostty.nix
    ./apps/niri.nix
    ./apps/chatgpt.nix
    ./apps/claude.nix
    ./apps/logseq.nix
    ./apps/localsend.nix
    ./apps/neurotracker.nix
    ./apps/chromium.nix
    ./apps/google-chrome.nix
    ./apps/google-meet.nix
    ./apps/google-calendar.nix
    ./apps/gmail.nix
    ./apps/slack.nix
    ./apps/cursor.nix
    ./apps/swaylock.nix
    ./apps/steam.nix
    ./apps/mako.nix
    ./apps/gtk.nix
    ./apps/walker.nix
    ./apps/typora.nix
    ./apps/warp.nix
    ./apps/mpv.nix
  ];
}
