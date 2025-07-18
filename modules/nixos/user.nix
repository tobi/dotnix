{ pkgs, home-manager, inputs, config, lib, ... }:

{
  imports = [
    ./dot.nix
    home-manager.nixosModules.home-manager
  ];

  # User configuration
  users.users.tobi = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "docker" "render" "input" "gamemode" "bluetooth" "plugdev" "libvirtd" ];
    description = "Tobi Lutke";
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";

    users.tobi.imports = [
      inputs.nix-colors.homeManagerModules.default
    ] ++ lib.optionals config.dotnix.home.enable [
      ../home-manager/home.nix
    ] ++ lib.optionals config.dotnix.desktop.enable [
      ../home-manager/desktop.nix
    ];

    extraSpecialArgs = {
      theme = config.dotnix.theme;
      inherit inputs;
    };
  };

  # Enable zsh system-wide since it's the user's shell
  programs.zsh.enable = true;

  # Desktop-specific configuration
  environment.sessionVariables = lib.mkIf config.dotnix.desktop.enable {

    # Ensure GUI apps work with Wayland (with X11 fallback)
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_STYLE_OVERRIDE = "kvantum";

    # Wayland-specific settings
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    SDL_VIDEODRIVER = "wayland";
    WAYLAND_DISPLAY = "wayland-1";
    OZONE_PLATFORM = "wayland";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";

    # XWayland for Steam and other X11 apps
    DISPLAY = ":0";
  };

  # Security wrapper for GUI apps
  security.polkit.enable = lib.mkIf config.dotnix.desktop.enable true;
  security.sudo.extraConfig = lib.mkIf config.dotnix.desktop.enable ''
    Defaults env_keep += "DISPLAY WAYLAND_DISPLAY XDG_RUNTIME_DIR XDG_SESSION_TYPE GDK_BACKEND QT_QPA_PLATFORM"
  '';
}
