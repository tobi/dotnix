{ pkgs, inputs, config, lib, ... }:
let
  sys = pkgs.stdenv.hostPlatform.system;
in
{
  imports = [
    ./envs.nix
    ./input.nix
    ./outputs.nix
    ./layout.nix
    ./binds.nix
    ./startup.nix
    ./window-rules.nix
  ];

  config = lib.mkIf (config.dotnix.wm == "hyprland") {
    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${sys}.hyprland;
      portalPackage = inputs.hyprland.packages.${sys}.xdg-desktop-portal-hyprland;
    };

    services.hyprpolkitagent.enable = true;
  };
}
