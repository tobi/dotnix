{ lib, inputs, ... }:
{
  imports = [
    inputs.niri.nixosModules.niri
  ];

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

  dotnix.desktop.enable = lib.mkDefault true;
}
