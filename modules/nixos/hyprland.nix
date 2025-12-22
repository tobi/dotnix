{ lib, pkgs, inputs, config, ... }:
let
in
{
  config = lib.mkIf (config.dotnix.desktop.enable && config.dotnix.wm == "hyprland") {
    # Use Hyprland from nixpkgs to avoid flake-input packaging/eval issues.
    # programs.uswm.enable = true;

    programs.hyprland = {
      enable = true;
      #withUSWM = true;

      package = pkgs.hyprland;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;

      # plugins = [
      # inputs.hyprland-plugins.packages.${pkgs.system}.hyprland-plugins.hyprland-plugins
      # ];
    };

    hardware.graphics = {
      # if you also want 32-bit support (e.g for Steam)
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
