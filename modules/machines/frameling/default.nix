# Frameling Desktop Configuration
{ inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix
    ../../nixos/common.nix
    ../../nixos/user.nix
    ../../nixos/niri.nix
    ../../nixos/warp.nix
    ../../nixos/authentication.nix
    ../../nixos/audio.nix

    inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
  ];

  # Machine identity
  networking.hostName = "frameling";

  # Enable desktop environment
  dotnix.home.enable = true;
  dotnix.desktop.enable = true;
  dotnix.desktop.launcher = "fuzzel";

  # Theme configuration
  dotnix.theme.name = "everforest";
  dotnix.theme.variant = "dark";
}

