# WSL2 Development Environment
{ inputs, ... }:

{
  imports = [
    ./configuration.nix
    ../../nixos/common.nix
    ../../nixos/user.nix

    inputs.nixos-wsl.nixosModules.wsl
  ];

  # Machine identity
  networking.hostName = "zerg-wsl2";

  # WSL configuration
  wsl.enable = true;
  wsl.defaultUser = "tobi";

  # WSL doesn't need desktop environment
  dotnix = {
    home.enable = true;
    desktop.enable = false;
  };
}
