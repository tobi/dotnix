{ lib, pkgs, ... }:

{
  imports = [
    ./theme.nix
  ];

  options.dotnix = {
    home = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable dotnix home configuration";
      };
    };

    desktop = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable dotnix desktop configuration";
      };

      wm = lib.mkOption {
        type = lib.types.enum [ "niri" "hyprland" ];
        default = "niri";
        description = "Window manager to use (niri or hyprland)";
      };

      assertions = [
        (lib.hm.assertions.assertPlatform "dotnix.desktop only works on NixOS" pkgs lib.platforms.nixos)
        (lib.hm.assertions.assertPlatform "dotnix.desktop only works on Linux" pkgs lib.platforms.linux)
      ];
    };
  };

}
