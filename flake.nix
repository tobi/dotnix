{
  description = "Tobi's dotfiles/homelab";

  outputs =
    { self
    , nixpkgs
    , determinate
    , home-manager
    , ...
    } @inputs:
    let
      # Support both Linux and Darwin
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      # Helper function to generate packages for each system
      forEachSystem = nixpkgs.lib.genAttrs systems;

      # Generate pkgs for each system
      mkNixPkgs =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            inputs.niri.overlays.niri
          ];
        };

      config = {
        user = "tobi";
        full_name = "Tobi Lutke";
        email_address = "tobi@lutke.com";
        theme = "tokyo-night";
      };

      # Import common lib functions
      lib = import ./lib/common.nix { inherit nixpkgs inputs config; };
    in
    {

      # ------------------------------------------------------------
      # NixOS configurations
      # ------------------------------------------------------------
      nixosConfigurations = {
        "zerg-wsl2" = lib.mkNixosSystem {
          system = "x86_64-linux";
          modules = [
            ./machines/zerg-wsl2/configuration.nix
            (lib.mkHome [ ./home/home.nix ])
          ];
        };

        # New configuration for the USB stick
        # RUN: nix build .#nixosConfigurations.usb-stick.config.system.build.isoImage
        "usb-stick" = lib.mkNixosSystem {
          system = "x86_64-linux";
          modules = [
            ./machines/usb-stick/configuration.nix
            (lib.mkHome [ ./home/home.nix ])
          ];
        };

        "frameling" = lib.mkNixosSystem {
          system = "x86_64-linux";
          modules = [
            ./machines/frameling/configuration.nix
            (lib.mkHome [
              ./home/home.nix
              ./desktop/desktop.nix
            ])
          ];
        };
      };

      # ------------------------------------------------------------
      # Home Manager configurations
      # ------------------------------------------------------------
      homeConfigurations = forEachSystem (system: {
        "tobi" = home-manager.lib.homeManagerConfiguration {
          pkgs = mkNixPkgs system;
          extraSpecialArgs = { inherit config; };
          modules = [ ./home/home.nix ];
        };
      });


      # ------------------------------------------------------------
      # Development shell (nix develop .)
      # ------------------------------------------------------------
      # Development shells for both systems
      devShells = forEachSystem (system:
        let devConfig = import ./devshell.nix { inherit nixpkgs system; };
        in devConfig.devShells.${system}
      );

      # Packages for both systems
      packages = forEachSystem (system:
        let devConfig = import ./devshell.nix { inherit nixpkgs system; };
        in devConfig.packages.${system}
      );
    };

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    niri.url = "github:sodiboo/niri-flake";
    nix-colors.url = "github:misterio77/nix-colors";
  };

}
