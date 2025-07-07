{ config, lib, pkgs, ... }:

{
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
    };
  };
}
