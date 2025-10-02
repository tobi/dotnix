{ nixpkgs }:

{
  mkMachines = { inputs, machinesPath }:
    let
      # Hardcode host names for now
      hostNames = [ "frameling" "zerg-wsl2" "usb-stick" "beetralisk" ];

      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
        overlays = [
          inputs.niri.overlays.niri
        ];
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
      hostNames);
}

