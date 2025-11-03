{ lib, pkgs, inputs, config, ... }:
{
  config = lib.mkIf (config.dotnix.desktop.enable && config.dotnix.desktop.wm == "hyprland") {
    programs.hyprland = {
      enable = true;
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
