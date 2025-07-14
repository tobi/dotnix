# WSL2 Development Environment
{ inputs, pkgs, theme, home-manager, config, lib, ... }:

{
  system = "x86_64-linux";

  imports = [
    ./configuration.nix
    inputs.nixos-wsl.nixosModules.wsl
    home-manager.nixosModules.home-manager
  ];

  # Machine identity
  networking.hostName = "zerg-wsl2";

  # WSL configuration
  wsl.enable = true;
  wsl.defaultUser = "tobi";

  # Home Manager configuration for this machine
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";

    users.tobi.imports = [
      inputs.nix-colors.homeManagerModules.default
      ../../home-manager/home.nix
    ];

    extraSpecialArgs = {
      inherit theme inputs;
    };
  };
}
