# Beetralisk Configuration
{ inputs, pkgs, theme, home-manager, config, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix
    ../../nixos/user.nix
    ../../nixos/niri.nix
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  # Machine identity
  networking.hostName = "beetralisk";

  # Enable desktop environment
  dotnix.desktop.enable = true;
}