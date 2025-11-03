{ nixpkgs }:

let

  # Function to create pkgs with all overlays
  mkPkgs =
    { system
    , extraOverlays ? [ ]
    ,
    }:
    import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = extraOverlays;
      inherit extraOverlays;
    };

in
{
  # Create NixOS machines with consistent overlay setup
  mkMachines =
    { inputs
    , machinesPath
    , extraOverlays ? [ ]
    ,
    }:
    let
      # Hardcode host names for now
      hostNames = builtins.attrNames (builtins.readDir machinesPath);

      # Use our centralized overlay system
      pkgs = mkPkgs {
        system = "x86_64-linux";
        inherit extraOverlays;
      };
    in
    builtins.listToAttrs (
      map
        (name: {
          inherit name;
          value = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            inherit pkgs;
            specialArgs = {
              inherit inputs;
              inherit (inputs) home-manager;
            };
            modules = [
              # inputs.determinate.nixosModules.default
              inputs.hyprland.nixosModules.default

              (machinesPath + "/${name}/default.nix")
            ];
          };
        })
        hostNames
    );

  # Expose the overlay system for use in flake.nix
  inherit mkPkgs;
}
