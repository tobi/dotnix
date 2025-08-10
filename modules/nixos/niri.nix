{ config, lib, pkgs, inputs, ... }:
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
        # this is a bit fragile, but gets us auto-reloading...
        command = "niri --session --config /home/tobi/dotnix/config/niri/config.kdl";
        user = "tobi";
      };
    };
  };

  services = {
    dbus.enable = true;
    gnome.gnome-keyring.enable = true;
    power-profiles-daemon.enable = true;
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
  };

  dotnix.desktop.enable = lib.mkDefault true;
}

