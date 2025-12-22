{ config, lib, ... }:
{
  config = lib.mkIf (config.dotnix.wm == "hyprland") {
    services.hypridle = {
    enable = true;

    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "pidof hyprlock || hyprlock";
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
      };

      listener = [
        # Lock screen after 5 minutes of inactivity
        {
          timeout = 300;
          on-timeout = "pidof hyprlock || hyprlock";
        }

        # Turn off displays after 5.5 minutes
        {
          timeout = 330;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on && brightnessctl -r";
        }

        # Warning notification before suspend
        {
          timeout = 355;
          on-timeout = "notify-send 'System will suspend in 5 seconds' -u critical -t 5000";
        }

        # Suspend after 6 minutes
        {
          timeout = 360;
          on-timeout = "systemctl suspend-then-hibernate";
        }
      ];
    };
    };
  };
}
