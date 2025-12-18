{ inputs, ... }:

{
  imports = [
    ./configuration.nix
    ../../nixos/common.nix
    ../../nixos/user.nix
  ];

  networking.hostName = "git";

  dotnix = {
    home.enable = false;
    desktop.enable = false;
  };
}
