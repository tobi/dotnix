{ nixpkgs
, inputs
, config
}:
let
  themes = import ./themes.nix;
  selectedTheme = themes.${config.theme};
in
{
  mkNixosSystem =
    { system
    , specialArgs ? { }
    , modules
    , homeModules ? [ ./home/home.nix ]
    , homeSpecialArgs ? { }
    }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = specialArgs // {
        home-manager = inputs.home-manager;
        nixos-wsl = inputs.nixos-wsl;
      };
      modules = modules ++ [
        inputs.determinate.nixosModules.default
        inputs.home-manager.nixosModules.home-manager
      ];
    };

  mkHome = modules: {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.backupFileExtension = "backup";
    home-manager.users.${config.user}.imports = modules ++ [
      inputs.niri.homeModules.niri
      inputs.nix-colors.homeManagerModules.default
      {
        colorScheme = inputs.nix-colors.colorSchemes.${selectedTheme.base16-theme};
      }
    ];
    home-manager.extraSpecialArgs = {
      nixos-wsl = inputs.nixos-wsl;
    };
  };
}
