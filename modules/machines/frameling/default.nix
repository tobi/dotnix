# Frameling Desktop Configuration
{ inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix
    ../../nixos/common.nix
    ../../nixos/user.nix
    ../../nixos/wm.nix
    ../../nixos/warp.nix
    ../../nixos/authentication.nix
    ../../nixos/audio.nix

    inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
  ];

  # Machine identity
  networking.hostName = "frameling";

  # Enable desktop environment with theme configuration
  dotnix = {
    home.enable = true;
    desktop.enable = true;
    wm = "hyprland";
    theme = {
      name = "everforest";
      variant = "dark";
    };
  };
}
