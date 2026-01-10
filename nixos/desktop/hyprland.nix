/*
  Hyprland System Configuration

  System-level Hyprland setup including:
  - Compositor and portal packages
  - Display manager (greetd)
  - Graphics and XWayland
  - PAM configuration for hyprlock
*/

{ lib, pkgs, config, ... }:

{
  config = lib.mkIf config.dotnix.desktop.enable {
    programs.hyprland = {
      enable = true;
      package = pkgs.hyprland;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
    };

    hardware.graphics = {
      enable32Bit = true;
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
