# Live USB Installer Configuration
{ inputs, pkgs, theme, home-manager, config, lib, modulesPath, ... }:

{
  system = "x86_64-linux";

  imports = [
    ./configuration.nix
    (modulesPath + "/installer/cd-dvd/installation-cd-base.nix")
    (modulesPath + "/installer/cd-dvd/iso-image.nix")
    home-manager.nixosModules.home-manager
  ];

  # Machine identity
  networking.hostName = "nixos-live";

  # Auto-login configuration for live environment
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "Hyprland";
        user = "tobi";
      };
    };
  };

  # Home Manager configuration for this machine
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";

    users.tobi.imports = [
      inputs.nix-colors.homeManagerModules.default
      ../../home-manager/home.nix
      ../../home-manager/desktop.nix
    ];

    extraSpecialArgs = {
      inherit theme inputs;
    };
  };
}
