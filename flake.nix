{
  description = "Tobi's dotfiles/homelab";

  outputs =
    { self
    , nixpkgs
    , determinate
    , home-manager
    , nixos-wsl
    , niri
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
            niri.overlays.niri
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
            inherit inputs theme home-manager niri nix-colors;
            modules-home = [
              ./home/home.nix
            ];
          };
          modules = [
            ./machines/zerg-wsl2/configuration.nix
          ];
        };

        # New configuration for the USB stick
        # RUN: nix build .#nixosConfigurations.usb-stick.config.system.build.isoImage
        "usb-stick" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = mkPkgs "x86_64-linux";
          specialArgs = {
            inherit inputs theme home-manager niri nix-colors;
            modules-home = [
              ./home/home.nix
              ./desktop/desktop.nix
            ];
          };
          modules = [
            ./machines/usb-stick/configuration.nix
          ];
        };

        "frameling" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = mkPkgs "x86_64-linux";
          specialArgs = {
            inherit inputs theme home-manager niri nix-colors;
            modules-home = [
              ./home/home.nix
              ./desktop/desktop.nix
            ];
          };
          modules = [
            ./machines/frameling/configuration.nix
          ];
        };
      };

      # ------------------------------------------------------------
      # Home Manager configurations
      # ------------------------------------------------------------
      homeConfigurations = forEachSystem (system: {
        "tobi" = home-manager.lib.homeManagerConfiguration {
          inherit system;
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
