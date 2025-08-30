# WSL2 Development Environment
{ inputs, pkgs, home-manager, config, lib, ... }:

{
  imports = [
    ./configuration.nix
    ../../nixos/common.nix
    inputs.nixos-wsl.nixosModules.wsl
    ../../nixos/user.nix
  ];

  # Machine identity
  networking.hostName = "zerg-wsl2";

  # WSL configuration
  wsl.enable = true;
  wsl.defaultUser = "tobi";

  # WSL doesn't need desktop environment
  dotnix.home.enable = true;
  dotnix.desktop.enable = false;


}

