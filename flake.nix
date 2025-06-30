{
  description = "Tobi's dotfiles/homelab";

  outputs = { self, nixpkgs, determinate, home-manager, ... } @inputs:
    let
      # Support both Linux and Darwin
      systems = [ "x86_64-linux" "aarch64-darwin" ];

      # Helper function to generate packages for each system
      forEachSystem = nixpkgs.lib.genAttrs systems;

      # Generate pkgs for each system
      pkgsFor = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          inputs.devshell.overlays.default
          inputs.niri.overlays.niri
        ];
      };

    in
    {

      # ------------------------------------------------------------
      # NixOS configurations
      # ------------------------------------------------------------
      nixosConfigurations = {
        "zerg-wsl2" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { nixos-wsl = inputs.nixos-wsl; };
          modules = [
            ./machines/zerg-wsl2/configuration.nix
            determinate.nixosModules.default
          ];
        };

        # New configuration for the live ISO
        # RUN: nix build .#nixosConfigurations.iso.config.system.build.isoImage
        "iso" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          # Pass home-manager to the module configuration
          specialArgs = { home-manager = inputs.home-manager; };
          modules = [
            ./machines/usb-stick/configuration.nix
          ];
        };

        "frameling" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { niri = inputs.niri; };
          modules = [
            ./machines/frameling/configuration.nix
            determinate.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";

              home-manager.users.tobi = {
                imports = [
                  ./home/home.nix
                  ./desktop/desktop.nix
                ];
              };
              home-manager.extraSpecialArgs = { niri = inputs.niri; };
            }
          ];
        };
      };

      # ------------------------------------------------------------
      # Home Manager configurations
      # ------------------------------------------------------------
      # Home Manager configurations
      homeConfigurations = {
        "tobi@frameling" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor "x86_64-linux";
          modules = [
            ./home/home.nix
            ./desktop/desktop.nix
          ];
        };

        "tobi@shopify-mbp" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor "aarch64-darwin";
          modules = [ ./home/home.nix ];
        };
      };

      # ------------------------------------------------------------
      # Development shell (nix develop .)
      # ------------------------------------------------------------
      # Development shells for both systems
      devShells = forEachSystem (system: {
        default = (pkgsFor system).devshell.fromTOML ./devshell.toml;
      });
    };


  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    devshell.url = "github:numtide/devshell";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    niri.url = "github:sodiboo/niri-flake";
  };

}
