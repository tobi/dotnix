{ pkgs, inputs, config, lib, ... }:
let
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
      package = pkgs.hyprland;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
    };

    services.hyprpolkitagent.enable = true;
  };
}
