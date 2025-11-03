{ lib, pkgs, inputs, config, ... }:
let
  sys = pkgs.stdenv.hostPlatform.system;
  pkgs-unstable = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  config = lib.mkIf (config.dotnix.desktop.enable && config.dotnix.desktop.wm == "hyprland") {
    # The Hyprland NixOS module (inputs.hyprland.nixosModules.default in utils.nix)
    # automatically provides the latest Hyprland package from the GitHub flake input
    # programs.uswm.enable = true;

    programs.hyprland = {
      enable = true;
      #withUSWM = true;

      # Package is automatically provided by hyprland.nixosModules.default
      # Currently provides: 0.51.0+date=2025-10-31_8e9add2
      package = inputs.hyprland.packages.${sys}.default;
      portalPackage = inputs.hyprland.packages.${sys}.xdg-desktop-portal-hyprland;

      # plugins = [
      # inputs.hyprland-plugins.packages.${pkgs.system}.hyprland-plugins.hyprland-plugins
      # ];
    };

    hardware.graphics = {
      package = pkgs-unstable.mesa;

      # if you also want 32-bit support (e.g for Steam)
      enable32Bit = true;
      package32 = pkgs-unstable.pkgsi686Linux.mesa;
    };

    programs = {
      xwayland.enable = true;
      dconf.enable = true;
    };

    # Display Manager
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "Hyprland";
          user = "tobi";
        };
      };
    };

    services = {
      dbus.enable = true;
      gnome.gnome-keyring.enable = true;
      power-profiles-daemon.enable = true;
    };

    # PAM configuration for hyprlock
    security.pam.services.hyprlock = {
      text = ''
        auth sufficient pam_fprintd.so
        auth include login
      '';
    };
  };
}
