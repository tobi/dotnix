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
    appimage-run
  ];

  programs.vscode.enable = true;
  programs.firefox.enable = true;
  programs.fuzzel.enable = true;
  programs.chromium.enable = true;
  programs.google-chrome.enable = true;

  # probably should go to home
  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };

  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    CHROMIUM_FLAGS = "--enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime --wayland-text-input-version=3";
  };

  services.gnome-keyring.enable = true;

  # XDG configuration for proper application launching
  xdg = {
    enable = true;
    mimeApps.enable = true;
  };

  home.shellAliases = {
    switch = "sudo nixos-rebuild switch --flake $DOTFILES && source ~/.zshrc";
  };

  imports = [
    ./waybar
    ./ghostty
    ./niri
    ./chatgpt
    ./chromium
    ./swaylock
  ];
}
