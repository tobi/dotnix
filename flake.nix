{
  description = "Tobi's dotfiles/homelab";
  outputs = { nixpkgs, devshell, home-manager, zen-browser, ... }:
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

      # Development shells for both systems
      devShells = forEachSystem (system: {
        default = (pkgsFor system).devshell.fromTOML ./devshell.toml;
      });

      # NixOS configurations
      nixosConfigurations = {
        iso = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { 
            inherit home-manager zen-browser;
          };
          modules = [
            ./machines/configuration.iso.nix
            # Add zen-browser overlay
            {
              nixpkgs.overlays = [
                (final: prev: {
                  zen-browser = zen-browser.packages.${prev.system}.default;
                })
              ];
            }
          ];
        };
      };
    };

  inputs = {
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
    
    home-manager.url = "https://flakehub.com/f/nix-community/home-manager/0";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    zen-browser.url = "github:MarceColl/zen-browser-flake";
  };

}
