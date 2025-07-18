{ nixpkgs }:

{
  mkMachines = { inputs, theme }:
    let
      machinesPath = ./modules/machines;
      machineNames = builtins.attrNames (builtins.readDir machinesPath);
      machineDirs = builtins.filter (name: 
        (builtins.readDir machinesPath).${name} == "directory"
      ) machineNames;
      
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
        overlays = [
          inputs.niri.overlays.niri
        ];
      };
    in
    builtins.listToAttrs (map (name: {
      name = name;
      value = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        inherit pkgs;
        specialArgs = {
          inherit inputs theme;
          home-manager = inputs.home-manager;
        };
        modules = [
          (machinesPath + "/${name}/default.nix")
        ];
      };
    }) machineDirs);
}