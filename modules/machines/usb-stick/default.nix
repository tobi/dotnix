# Live USB Installer Configuration
{
  inputs,
  modulesPath,
  ...
}:

{
  imports = [
    ./configuration.nix
    (modulesPath + "/installer/cd-dvd/installation-cd-base.nix")
    (modulesPath + "/installer/cd-dvd/iso-image.nix")
    ../../nixos/user.nix
    ../../nixos/niri.nix
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-gpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-amd
  ];

  # Machine identity
  networking.hostName = "nixos-live";

  # Enable desktop environment for live USB with theme configuration
  dotnix = {
    desktop.enable = true;
    theme = {
      name = "everforest";
      variant = "dark";
    };
  };

  # Auto-login configuration for live environment
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "niri-session";
        user = "tobi";
      };
    };
  };
}
