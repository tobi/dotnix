{
  description = "Tobi's homelab";
  outputs = { nixpkgs, devshell, nixos-wsl, determinate, ... }:
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
            ./configuration.zerg-wsl2.nix 
             determinate.nixosModules.default
          ];
        };
      };

      # Development shells for both systems
      devShells = forEachSystem (system: {
        default = (pkgsFor system).devshell.fromTOML ./devshell.toml;
      });
    };


  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";

    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";    

    nixos-wsl.url = "github:nix-community/NixOS-WSL";
  };

}
