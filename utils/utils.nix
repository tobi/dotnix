{ nixpkgs }:

let


  # Function to create pkgs with all overlays
  mkPkgs = { system, extraOverlays ? [ ] }:
    import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = extraOverlays;
    };

in
{
  # Create NixOS machines with consistent overlay setup
  mkMachines = { inputs, machinesPath, extraOverlays ? [ ] }:
    let
      # Hardcode host names for now
      hostNames = [ "frameling" "zerg-wsl2" "usb-stick" "beetralisk" ];

      # Use our centralized overlay system
      pkgs = mkPkgs {
        system = "x86_64-linux";
        extraOverlays = extraOverlays;
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
            inputs.determinate.nixosModules.default

            (machinesPath + "/${name}/default.nix")
          ];
        };
      })
      hostNames);

  # Expose the overlay system for use in flake.nix
  inherit mkPkgs;
}

