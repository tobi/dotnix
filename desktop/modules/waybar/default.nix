{ config
, lib
, pkgs
, ...
}:
let
  palette = config.colorScheme.palette;
  terminal = "${config.programs.alacritty.package}/bin/alacritty";
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
      #bluetooth, #wireplumber, #power-profiles-daemon, #custom-dropbox, #custom-tailscale
      {
        padding: 0px 10px;
        margin: 5px 0px;
        border-radius: 15px;
      }

      #battery.warning:not(.charging) {
        color: #${palette.base09};
      }

      #battery.critical:not(.charging) {
        color: #${palette.base08};
      }

      disconnected {
        color: #${palette.base08};
      }

      muted {
        color: #${palette.base03};
      }

      disabled {
        color: #${palette.base03};
      }

      .needs-login {
        color: #${palette.base09};
      }

      .stopped {
        color: #${palette.base08};
      }

      #custom-tailscale.unknown {
        color: #${palette.base03};
      }

      /* Tooltip styling */
      tooltip {
        background: #${palette.base00};
        color: #${palette.base05};
        border: 1px solid #${palette.base01};
        border-radius: 10px;
        padding: 5px 10px;
      }

      tooltip label {
        padding: 5px;
      }
    '';
    settings = [
      {
        layer = "top";
        position = "top";
        spacing = 4;
        height = 24;
        modules-left = [
          "niri/workspaces"
          "power-profiles-daemon"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "custom/dropbox"
          "custom/tailscale"
          "bluetooth"
          "network"
          "wireplumber"
          "memory"
          "cpu"
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
          persistent-workspaces = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
            "5" = [ ];
          };
        };
        cpu = {
          interval = 5;
          format = "󰍛 {usage}%";
          format-alt = "󰍛";
          on-click-right = "${terminal} -e btop";
          tooltip = true;
          tooltip-format = "CPU: {usage}%\nLoad: {load}";
        };
        clock = {
          format = "{:%A %H:%M}";
          format-alt = "{:%d %B W%V %Y}";
          tooltip = false;
        };
        network = {
          format-icons = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
          format = "{icon}";
          format-wifi = "{icon} ({frequency} GHz)";
          format-ethernet = "󰀂";
          format-disconnected = "󰖪";
          tooltip-format-wifi = "{essid} ({frequency} GHz)\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-ethernet = "⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-disconnected = "Disconnected";
          interval = 3;
          nospacing = 1;
          on-click = "${terminal} -e 'mtr 1.1.1.1'";
          on-click-right = "${terminal} -e nmtui";
        };
        battery = {
          interval = 5;
          format = "{icon} {capacity}%";
          format-discharging = "{icon} {capacity}%";
          format-charging = "{icon} {capacity}%";
          format-plugged = "{icon}";
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
          tooltip-format-discharging = "{power:>1.1f} watt↓ {capacity}%";
          tooltip-format-charging = "{power:>1.1f} watt↑ {capacity}%";
          states = {
            warning = 20;
            critical = 10;
          };
        };
        bluetooth = {
          format = "󰂯";
          format-connected = "󰂯";
          tooltip-format = "Devices connected: {num_connections}";
        };
        wireplumber = {
          format = "󰕾 {volume}%";
          format-muted = "󰝟";
          scroll-step = 3;
          on-click = "GTK_THEME=Adwaita-dark pavucontrol";
          tooltip-format = "Volume: {volume}%";
          on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          max-volume = 120;
          ignored-sinks = [ "Easy Effects Sink" ];
        };
        memory = {
          interval = 5;
          format = " {percentage:>50.0f}%";
          format-alt = " {used:0.1f}G/{total:0.1f}G";
          tooltip = true;
          tooltip-format = "Memory: {used:0.1f}GB / {total:0.1f}GB\nSwap: {swapUsed:0.1f}GB / {swapTotal:0.1f}GB";
        };
        power-profiles-daemon = {
          format = "{icon} {profile}";
          tooltip-format = "Power profile: {profile}";
          tooltip = true;
          format-icons = {
            power-saver = "󰡳";
            balanced = "󰊚";
            performance = "󰡴";
          };
        };
        "custom/dropbox" = {
          format = " {text}";
          return-type = "json";
          exec = "${./waybar-dropbox}";
          on-click = "${terminal} -e yazi ~/Dropbox";
          interval = 5;
          tooltip = true;
        };
        "custom/tailscale" = {
          format = "{icon}";
          return-type = "json";
          exec = "${./waybar-tailscale}";
          on-click = "tailscale ip -4 | wl-copy";
          on-click-right = "tailscale ip -6 | wl-copy";
          interval = 10;
          tooltip = true;
        };
      }
    ];
  };
}
