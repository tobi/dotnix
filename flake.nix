{
  description = "Tobi's nixworld";

  outputs =
    { nixpkgs
    , colmena
    , ...
    }@inputs:
    let
      # Support both Linux and Darwin
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      # Helper function to generate packages for each system
      forEachSystem = nixpkgs.lib.genAttrs systems;

      # Import utilities with centralized overlay system
      utils = import ./lib/utils.nix { inherit nixpkgs; };

      # Generate pkgs for home-manager using centralized overlay system

      # NixOS configurations (used by both nixosConfigurations and colmena)
      nixosConfigs = utils.mkMachines {
        inherit inputs;
        machinesPath = ./hosts;
        extraOverlays = [ ];
      };
    in
    {

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;

      # Expose colmena for `nix run .#colmena`
      packages = forEachSystem (system: {
        colmena = colmena.packages.${system}.colmena;
      });

      # ------------------------------------------------------------
      # NixOS configurations
      # ------------------------------------------------------------
      nixosConfigurations = nixosConfigs;

      # ------------------------------------------------------------
      # Colmena deployment configuration
      # ------------------------------------------------------------
      colmenaHive = colmena.lib.makeHive {
        meta = {
          nixpkgs = import nixpkgs { system = "x86_64-linux"; };
          specialArgs = { inherit inputs; };
        };

        # Server hosts - deployed remotely
        git = { ... }: {
          imports = [ ./hosts/git ];
          deployment = {
            targetHost = "git";
            targetUser = "root";
            tags = [ "server" "x86_64-linux" ];
          };
        };

        # Desktop hosts - deployed locally via `apply`
        frameling = { ... }: {
          imports = [ ./hosts/frameling ];
          deployment = {
            allowLocalDeployment = true;
            tags = [ "desktop" ];
          };
        };

        beetralisk = { ... }: {
          imports = [ ./hosts/beetralisk ];
          deployment = {
            allowLocalDeployment = true;
            tags = [ "desktop" ];
          };
        };
      };

      # ------------------------------------------------------------
      # Home Manager configurations
      # ------------------------------------------------------------
      # Home Manager is managed separately in home/flake.nix
      # Run: home-manager switch --flake ./home

      # ------------------------------------------------------------
      # Development shell (nix develop .)
      # ------------------------------------------------------------
      # Development shells for both systems
      devShells = forEachSystem (
        system:
        let
          devConfig = import ./devshell.nix { inherit nixpkgs system inputs; };
        in
        devConfig.devShells.${system}
      );

    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    colmena.url = "github:zhaofengli/colmena";
    colmena.inputs.nixpkgs.follows = "nixpkgs";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";
    # Don't follow nixpkgs - avoids nix-functional-tests hang in nix develop

    hyprland-plugins.url = "github:hyprwm/hyprland-plugins";
    hyprland-plugins.inputs.hyprland.follows = "hyprland";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-colors.url = "github:misterio77/nix-colors";

    try.url = "github:tobi/try-c";
    try.inputs.nixpkgs.follows = "nixpkgs";

    ghostty.url = "github:ghostty-org/ghostty";
    ghostty.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

}
