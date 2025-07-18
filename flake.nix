{
  description = "Tobi's nixworld";

  outputs =
    { self
    , nixpkgs
    , home-manager
    , nix-colors
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

      # Theme configuration
      theme = import ./config/themes.nix { inherit nix-colors; };

      # Generate pkgs with overlays and config
      mkPkgs = system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
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
          pkgs = mkPkgs "x86_64-linux";
          specialArgs = {
            inherit inputs theme home-manager;
          };
          modules = [
            ./modules/machines/zerg-wsl2/configuration.nix
          ];
        };

        # New configuration for the USB stick
        # RUN: nix build .#nixosConfigurations.usb-stick.config.system.build.isoImage
        "usb-stick" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = mkPkgs "x86_64-linux";
          specialArgs = {
            inherit inputs theme home-manager;
          };
          modules = [
            ./modules/machines/usb-stick/configuration.nix
          ];
        };

        "frameling" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = mkPkgs "x86_64-linux";
          specialArgs = {
            inherit inputs theme home-manager;
          };
          modules = [
            ./modules/machines/frameling/configuration.nix
          ];
        };

        "beeling" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = mkPkgs "x86_64-linux";
          specialArgs = {
            inherit inputs theme home-manager;
          };
          modules = [
            ./modules/machines/beeling/configuration.nix
          ];
        };
      };

      # ------------------------------------------------------------
      # Home Manager configurations
      # ------------------------------------------------------------
      homeConfigurations = {
        "tobi" = home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs "aarch64-darwin";
          modules = [ ./modules/home-manager/home.nix ];
        };
      };


      # ------------------------------------------------------------
      # Development shell (nix develop .)
      # ------------------------------------------------------------
      # Development shells for both systems
      devShells = forEachSystem
        (system:
          let devConfig = import ./devshell.nix { inherit nixpkgs system; };
          in devConfig.devShells.${system}
        );

    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    niri.url = "github:sodiboo/niri-flake";
    niri.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-colors.url = "github:misterio77/nix-colors";
  };

}
