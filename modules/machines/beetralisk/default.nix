# Beetralisk Configuration
{
  inputs,
  pkgs,
  home-manager,
  config,
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./disko-config.nix
    ./configuration.nix
    ../../nixos/common.nix
    ../../nixos/user.nix
    ../../nixos/niri.nix
    inputs.disko.nixosModules.disko
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  # Machine identity
  networking.hostName = "beetralisk";

  # Enable desktop environment
  dotnix.desktop.enable = true;

  # Theme configuration
  dotnix.theme.name = "everforest";
  dotnix.theme.variant = "dark";
}
