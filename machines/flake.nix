{
  description = "Tobi's homelab";

  inputs = {
    devshell.url = "github:numtide/devshell";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";

    niri.url = "github:sodiboo/niri-flake";
    home.url = "path:../home";
  };

  outputs = { self, devshell, nixos-wsl, niri, home, ... }:
    let
      # Support both Linux and Darwin
      systems = [ "x86_64-linux" "aarch64-darwin" ];

      # # Helper function to generate packages for each system
      # forEachSystem = nixpkgs.lib.genAttrs systems;

      # Generate pkgs for each system
      pkgsFor = system: import home.inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ devshell.overlays.default niri.overlays.niri home.overlays.default ];
      };

    in
    {


      # NixOS machine configurations
      nixosConfigurations = {
        "zerg-wsl2" = home.inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit nixos-wsl; };
          modules = [
            ./zerg-wsl2/configuration.nix
            home.inputs.determinate.nixosModules.default
          ];
        };

        # New configuration for the live ISO
        # RUN: nix build .#nixosConfigurations.iso.config.system.build.isoImage
        "iso" = home.inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          # Pass home-manager to the module configuration
          specialArgs = { home-manager = home.inputs.home-manager; };
          modules = [ ./usb-stick/configuration.nix ];
        };

        "frameling" = home.inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            niri = niri;
            home-manager = home.inputs.home-manager;
          };
          modules = [
            ./frameling/configuration.nix
            home.inputs.home-manager.nixosModules.home-manager
            home.inputs.determinate.nixosModules.default
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.tobi = {
                imports = home.homeConfigurations."tobi@frameling";
              };
            }
          ];
        };
      };

      # Development shells for both systems
      devShells = {
        default = devshell.fromTOML ./devshell.toml;
      };
    };
}
