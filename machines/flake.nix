{
  description = "Tobi's homelab";
  
  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    devshell.url = "github:numtide/devshell";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, devshell, nixos-wsl, determinate, home-manager, ... }:
    let
      # Support both Linux and Darwin
      systems = [ "x86_64-linux" "aarch64-darwin" ];
      
      # Helper function to generate packages for each system
      forEachSystem = nixpkgs.lib.genAttrs systems;
      
      # Generate pkgs for each system
      pkgsFor = system: import nixpkgs { 
        inherit system;
        config.allowUnfree = true;
        overlays = [ devshell.overlays.default ];
      };

    in {
      # NixOS machine configurations
      nixosConfigurations = {
        "zerg-wsl2" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit nixos-wsl; };
          modules = [ 
            ./zerg-wsl2/configuration.nix 
            determinate.nixosModules.default
          ];
        };

        # New configuration for the live ISO
        # RUN: nix build .#nixosConfigurations.iso.config.system.build.isoImage
        "iso" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          # Pass home-manager to the module configuration
          specialArgs = { inherit home-manager; };
          modules = [ ./usb-stick/configuration.nix ];
        };
      };

      packages.x86_64-linux.iso = self.nixosConfigurations.iso.config.system.build.isoImage;

      # Development shells for both systems
      devShells = forEachSystem (system: {
        default = (pkgsFor system).devshell.fromTOML ./devshell.toml;
      });
    };
}
