# Frameling Desktop Configuration
{ inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix
    ../../nixos/common.nix
    ../../nixos/user.nix
    ../../nixos/desktop
    ../../nixos/services

    inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
  ];

  # Machine identity
  networking.hostName = "frameling";

  # Enable desktop environment with theme configuration
  dotnix = {
    home.enable = true;
    desktop.enable = true;
    theme = {
      name = "everforest";
      variant = "dark";
    };
    services.warp.enable = true;
  };
}
