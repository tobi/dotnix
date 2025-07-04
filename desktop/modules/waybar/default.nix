{ config
, lib
, pkgs
, ...
}:
let
  palette = config.colorScheme.palette;
in
{
  programs.waybar = {
    enable = true;
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "FiraCode Nerd Font", monospace;
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: #${palette.base00};
        color: #${palette.base05};
        transition-property: background-color;
        transition-duration: 0.5s;
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      #workspaces {
        background: #${palette.base01};
        margin: 5px;
        padding: 0px 1px;
        border-radius: 15px;
        border: 0px;
        font-style: normal;
        color: #${palette.base05};
      }

      #workspaces button {
        padding: 0px 5px;
        margin: 4px 3px;
        border-radius: 15px;
        border: 0px;
        color: #${palette.base05};
        background: transparent;
        transition: all 0.3s ease-in-out;
      }

      #workspaces button.active {
        color: #${palette.base0D};
        background: #${palette.base02};
        border-radius: 15px;
        min-width: 40px;
        transition: all 0.3s ease-in-out;
      }

      #workspaces button:hover {
        color: #${palette.base0B};
        background: #${palette.base02};
        border-radius: 15px;
      }

      #clock, #cpu, #memory, #disk, #temperature, #network, #battery,
      #bluetooth, #wireplumber, #power-profiles-daemon {
        background: #${palette.base01};
        padding: 0px 10px;
        margin: 5px 0px;
        border-radius: 15px;
        color: #${palette.base05};
      }

      #clock {
        color: #${palette.base0D};
      }

      #cpu {
        color: #${palette.base0A};
      }

      #battery {
        color: #${palette.base0B};
      }

      #battery.charging {
        color: #${palette.base0D};
      }

      #battery.warning:not(.charging) {
        color: #${palette.base09};
      }

      #battery.critical:not(.charging) {
        color: #${palette.base08};
      }

      #network {
        color: #${palette.base0C};
      }

      #network.disconnected {
        color: #${palette.base08};
      }

      #wireplumber {
        color: #${palette.base0E};
      }

      #wireplumber.muted {
        color: #${palette.base03};
      }

      #bluetooth {
        color: #${palette.base0D};
      }

      #bluetooth.disabled {
        color: #${palette.base03};
      }

      #power-profiles-daemon {
        color: #${palette.base0A};
      }
    '';
    settings = [
      {
        layer = "top";
        position = "top";
        spacing = 0;
        height = 26;
        modules-left = [
          "niri/workspaces"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "bluetooth"
          "network"
          "wireplumber"
          "cpu"
          "power-profiles-daemon"
          "battery"
        ];
        "niri/workspaces" = {
          on-click = "activate";
          format = "{icon}";
          format-icons = {
            default = "";
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            active = "󱓻";
          };
        };
        cpu = {
          interval = 5;
          format = "󰍛";
          on-click = "ghostty -e btop";
        };
        clock = {
          format = "{:%A %I:%M %p}";
          format-alt = "{:%d %B W%V %Y}";
          tooltip = false;
        };
        network = {
          format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
          format = "{icon}";
          format-wifi = "{icon}";
          format-ethernet = "󰀂";
          format-disconnected = "󰖪";
          tooltip-format-wifi = "{essid} ({frequency} GHz)\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-ethernet = "⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-disconnected = "Disconnected";
          interval = 3;
          nospacing = 1;
          on-click = "ghostty -e nmcli";
        };
        battery = {
          interval = 5;
          format = "{capacity}% {icon}";
          format-discharging = "{icon}";
          format-charging = "{icon}";
          format-plugged = "";
          format-icons = {
            charging = [
              "󰢜"
              "󰂆"
              "󰂇"
              "󰂈"
              "󰢝"
              "󰂉"
              "󰢞"
              "󰂊"
              "󰂋"
              "󰂅"
            ];
            default = [
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
          };
          format-full = "Charged ";
          tooltip-format-discharging = "{power:>1.0f}W↓ {capacity}%";
          tooltip-format-charging = "{power:>1.0f}W↑ {capacity}%";
          states = {
            warning = 20;
            critical = 10;
          };
        };
        bluetooth = {
          format = "󰂯";
          format-disabled = "󰂲";
          format-connected = "";
          tooltip-format = "Devices connected: {num_connections}";
          on-click = "GTK_THEME=Adwaita-dark blueberry";
        };
        wireplumber = {
          format = "";
          format-muted = "󰝟";
          scroll-step = 5;
          on-click = "GTK_THEME=Adwaita-dark pavucontrol";
          tooltip-format = "Playing at {volume}%";
          on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          max-volume = 150;
        };
        power-profiles-daemon = {
          format = "{icon}";
          tooltip-format = "Power profile: {profile}";
          tooltip = true;
          format-icons = {
            power-saver = "󰡳";
            balanced = "󰊚";
            performance = "󰡴";
          };
        };
      }
    ];
  };
}
