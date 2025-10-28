# Beetralisk Configuration
{ inputs, ... }:

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

  # Enable desktop environment with theme configuration
  dotnix = {
    desktop.enable = true;
    theme = {
      name = "everforest";
      variant = "dark";
    };
  };
}
