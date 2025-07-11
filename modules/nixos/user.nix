{ pkgs, home-manager, theme, inputs, config, lib, ... }:

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
      inputs.niri.homeModules.niri
    ] ++ lib.optionals config.dotnix.home.enable [
      ../home-manager/home.nix
    ] ++ lib.optionals config.dotnix.desktop.enable [
      ../home-manager/desktop.nix
    ];

    extraSpecialArgs = {
      inherit theme inputs;
    };
  };

  # Enable zsh system-wide since it's the user's shell
  programs.zsh.enable = true;

  # Desktop-specific configuration
  environment.sessionVariables = lib.mkIf config.services.greetd.enable {

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
  };

  # Security wrapper for GUI apps
  security.polkit.enable = true;
  security.sudo.extraConfig = ''
    Defaults env_keep += "WAYLAND_DISPLAY XDG_RUNTIME_DIR XDG_SESSION_TYPE GDK_BACKEND QT_QPA_PLATFORM"
  '';
}
