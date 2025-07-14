# Frameling Desktop Configuration
{ inputs, pkgs, theme, home-manager, config, lib, ... }:

{
  system = "x86_64-linux";

  imports = [
    ./hardware-configuration.nix
    ./configuration.nix
    home-manager.nixosModules.home-manager
  ];

  # Machine identity
  networking.hostName = "frameling";

  # Home Manager configuration for this machine
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";

    users.tobi.imports = [
      inputs.nix-colors.homeManagerModules.default
      inputs.niri.homeModules.niri
      ../../home-manager/home.nix
      ../../home-manager/desktop.nix
    ];

    extraSpecialArgs = {
      inherit theme inputs;
    };
  };
}
