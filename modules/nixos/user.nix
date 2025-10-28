{
  pkgs,
  home-manager,
  inputs,
  config,
  lib,
  ...
}:

{
  imports = [
    ./config.nix
    ./environment.nix
    home-manager.nixosModules.home-manager
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

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";

    users.tobi.imports = [
      inputs.nix-colors.homeManagerModules.default
    ]
    ++ lib.optionals config.dotnix.home.enable [
      ../home-manager/home.nix
    ]
    ++ lib.optionals config.dotnix.desktop.enable [
      ../home-manager/desktop.nix
    ];

    extraSpecialArgs = {
      inherit inputs;
      inherit (config.dotnix) theme;
    };
  };

  # Enable zsh system-wide since it's the user's shell
  programs.zsh.enable = true;

  # Desktop-specific configuration

  # Security wrapper for GUI apps
  security.polkit.enable = lib.mkIf config.dotnix.desktop.enable true;
  security.sudo.extraConfig = lib.mkIf config.dotnix.desktop.enable ''
    Defaults env_keep += "DISPLAY WAYLAND_DISPLAY XDG_RUNTIME_DIR XDG_SESSION_TYPE GDK_BACKEND QT_QPA_PLATFORM"
  '';
}
