{
  description = "Tobi's dotfiles/homelab";
  outputs = { nixpkgs, devshell, ... }:
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
    };


  inputs = {
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";    
  };

}
