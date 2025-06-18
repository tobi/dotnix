{
  description = "Tobi's dotfiles";
  outputs = { self, nixpkgs, home-manager, ... }:
    let
      # Support both Linux and Darwin
      systems = [ "x86_64-linux" "aarch64-darwin" ];

      # Helper function to generate packages for each system
      forEachSystem = nixpkgs.lib.genAttrs systems;

      # Generate pkgs for each system
      pkgsFor = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

    in {

      # Home Manager configurations
      homeConfigurations = {
        # windows
        "tobi@zerg-wsl2" = home-manager.lib.homeManagerConfiguration  {
          pkgs = pkgsFor "x86_64-linux";
          modules = [ ./home.nix ];
        };

        "tobi@shopify-mbp-2" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor "aarch64-darwin";
          modules = [ ./home.nix ];
        };
      };

    };


  inputs = {
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";

    home-manager.url = "https://flakehub.com/f/nix-community/home-manager/0";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

  };

}
