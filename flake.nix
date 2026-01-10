{
  description = "Tobi's nixworld";

  outputs =
    { nixpkgs
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
      mkPkgs =
        system:
        utils.mkPkgs {
          inherit system;

          extraOverlays = [
            # (import ./modules/overlays/ruby.nix)
          ];
        };
    in
    {

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;

      # ------------------------------------------------------------
      # NixOS configurations
      # ------------------------------------------------------------
      nixosConfigurations = utils.mkMachines {
        inherit inputs;
        machinesPath = ./hosts;
        extraOverlays = [ ];
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
    # determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    # nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";


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
