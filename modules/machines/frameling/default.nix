# Frameling Desktop Configuration
{ inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix
    ../../nixos/user.nix
    ../../nixos/niri.nix
    inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
  ];

  # Machine identity
  networking.hostName = "frameling";

  # Enable desktop environment
  dotnix.home.enable = true;
  dotnix.desktop.enable = true;

  dotnix.themeName = "everforest";
}
