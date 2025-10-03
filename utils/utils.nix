{ nixpkgs }:

let
  # Centralized overlay system
  overlays = [
    # External overlays
    # Local overlays
    (import ../modules/overlays/ruby.nix)
  ];

  # Function to create pkgs with all overlays
  mkPkgs = { system, extraOverlays ? [] }:
    import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = overlays ++ extraOverlays;
    };

in
{
<<<<<<< HEAD
  mkMachines = { inputs, machinesPath }:
=======
  # Create NixOS machines with consistent overlay setup
  mkMachines = { inputs, extraOverlays ? [] }:
>>>>>>> 87ad270 (Refactor overlay system to be more elegant and encapsulated)
    let
      # Hardcode host names for now
      hostNames = [ "frameling" "zerg-wsl2" "usb-stick" "beetralisk" ];

      # Use our centralized overlay system
      pkgs = mkPkgs {
        system = "x86_64-linux";
        extraOverlays = [ inputs.niri.overlays.niri ] ++ extraOverlays;
      };
    in
    builtins.listToAttrs (map
      (name: {
        name = name;
        value = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          inherit pkgs;
          specialArgs = {
            inherit inputs;
            home-manager = inputs.home-manager;
          };
          modules = [
            (machinesPath + "/${name}/default.nix")
          ];
        };
      })
<<<<<<< HEAD
      hostNames);
=======
      machineDirs);

  # Expose the overlay system for use in flake.nix
  inherit overlays mkPkgs;
>>>>>>> 87ad270 (Refactor overlay system to be more elegant and encapsulated)
}

