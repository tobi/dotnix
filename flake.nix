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
      # Import overlays
      rubyOverlay = import ./modules/overlays/ruby.nix;
      # Support both Linux and Darwin
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      # Helper function to generate packages for each system
      forEachSystem = nixpkgs.lib.genAttrs systems;

      # Import utilities
      utils = import ./utils/utils.nix { inherit nixpkgs; };

      # Generate pkgs for home-manager
      mkPkgs = system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            inputs.niri.overlays.niri
            rubyOverlay
          ];
        };
    in
    {

      # ------------------------------------------------------------
      # NixOS configurations
      # ------------------------------------------------------------
      nixosConfigurations = utils.mkMachines {
        inherit inputs;
        machinesPath = ./modules/machines;
      };

      # ------------------------------------------------------------
      # Home Manager configurations
      # ------------------------------------------------------------
<<<<<<< HEAD
      homeConfigurations = forEachSystem
        (system:
          let pkgs = mkPkgs system;
          in home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [ ./modules/home-manager/home.nix ];
          }
        );
=======
      # Home Manager expects `homeConfigurations.<name>` at the top level.
      # Provide a concrete configuration for the local Darwin user "tobi".
      homeConfigurations = {
        "tobi" = home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs "aarch64-darwin";
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./modules/home-manager/home.nix ];
        };
      };
>>>>>>> 1a6d3d9 (Add ruby jemalloc overlay to enable jemalloc support for all Ruby versions)


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

    try.url = "github:tobi/try";
    try.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

  };

}

