{ inputs, ... }:
inputs.nixpkgs.lib.nixosSystem {
  modules = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
    inputs.determinate.nixosModules.default

    inputs.omarchy-nix.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
    {
      # System configuration
      system.stateVersion = "25.05";
      networking.hostName = "frameling-oma";
      time.timeZone = "America/Toronto";

      # Boot configuration (required)
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      # Configure omarchy
      omarchy = {
        full_name = "Tobi Lutke";
        email_address = "tobi@lutke.com";
        theme = "tokyo-night";
      };

      # Create the user that home-manager expects
      users.users.tobi = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
        description = "Tobi Lutke";
      };

      programs.zsh.enable = true;

      home-manager.backupFileExtension = "backup-omsa";
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.tobi = {
          home.stateVersion = "25.05";
          imports = [
            inputs.omarchy-nix.homeManagerModules.default
          ];
        };
      };
    }
  ];
}
