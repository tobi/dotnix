{ lib, inputs, config, ... }:
{
  imports = [
    inputs.niri.nixosModules.niri
  ];

  config = lib.mkIf (config.dotnix.desktop.enable && config.dotnix.desktop.wm == "niri") {
    programs = {
      niri.enable = true;
      xwayland.enable = true;
      dconf.enable = true;
    };

    # Display Manager
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "niri-session";
          user = "tobi";
        };
      };
    };

    services = {
      dbus.enable = true;
      gnome.gnome-keyring.enable = true;
      power-profiles-daemon.enable = true;
    };
  };
}
