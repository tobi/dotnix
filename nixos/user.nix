{
  pkgs,
  config,
  lib,
  ...
}:

{
  imports = [
    ./config.nix
  ];

  # User configuration
  users.users.tobi = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "docker"
      "render"
      "input"
      "gamemode"
      "bluetooth"
      "plugdev"
      "libvirtd"
    ];
    description = "Tobi Lutke";
  };

  # Desktop-specific configuration

  # Security wrapper for GUI apps
  security.polkit.enable = lib.mkIf config.dotnix.desktop.enable true;
  security.sudo.extraConfig = lib.mkIf config.dotnix.desktop.enable ''
    Defaults env_keep += "DISPLAY WAYLAND_DISPLAY XDG_RUNTIME_DIR XDG_SESSION_TYPE GDK_BACKEND QT_QPA_PLATFORM"
  '';
}
