{ nixpkgs, inputs, config ? { user = "tobi"; } }:
{
  mkNixosSystem = { system, specialArgs ? { }, modules, homeModules ? [ ./home/home.nix ], homeSpecialArgs ? { } }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = specialArgs;
      modules = modules ++ [
        inputs.determinate.nixosModules.default
        inputs.home-manager.nixosModules.home-manager
      ];
    };

  mkHomeManager = { modules ? [ ], extraSpecialArgs ? { } }: {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.backupFileExtension = "backup";
    home-manager.users.${config.user}.imports = modules;
    home-manager.extraSpecialArgs = extraSpecialArgs // { nixos-wsl = inputs.nixos-wsl; };
  };
}
