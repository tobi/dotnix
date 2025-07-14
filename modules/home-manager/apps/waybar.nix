{ config
, theme
, pkgs
, ...
}:
let
  palette = theme.palette;
  terminal = "${pkgs.alacritty}/bin/alacritty";
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
        transition-property: height;
        transition-duration: 0.5s;
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      #workspaces {
        background: #${palette.base01};
        margin: 0px 5px;
        padding: 0px 1px;
        border-radius: 15px;
        border: 0px;
        font-style: normal;
        color: #${palette.base05};
      }

      #workspaces button {
        padding: 0px 5px;
        margin: 0px 3px;
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

      .modules-left, .modules-center, .modules-right {
        background: #${palette.base01};
        margin: 0px 5px;
        padding: 0px 1px;
        border-radius: 15px;
        border: 0px;
      }


      #clock, #cpu, #memory, #disk, #temperature, #network, #battery,
      #bluetooth, #wireplumber, #power-profiles-daemon, #custom-dropbox, #custom-tailscale, #mpris
      {
        margin: 0px 5px;
        min-width: 15px;
      }

      #tray {
        /* margin-left: 40px; */
      }

      #cpu, #memory, #battery, #wireplumber{
        min-width: 45px;
      }

      #battery.warning:not(.charging) {
        color: yellow;
      }

      #battery.critical:not(.charging). .disconneted {
        color: red;
        animation: pulse 10s ease-in-out infinite;
      }

      .muted {
        color: #${palette.base03};
      }

      .disabled {
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

      #mpris{
        padding: 0 20px;
      }

      #mpris.playing {
        color: #${palette.base0B};
      }

      #mpris.paused {
        color: #${palette.base0A};
      }

      #mpris.stopped {
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
        spacing = 0;
        height = 28;
        modules-left = [
          "niri/workspaces"
          "power-profiles-daemon"
          "custom/terminals"
          "mpris"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "wireplumber"
          "cpu"
          "memory"
          "network"
          "bluetooth"
          "custom/tailscale"
          "custom/dropbox"
          "tray"
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
            "1" = [ "Default" ];
            "2" = [ "Dev" ];
            "3" = [ "Steam" ];
            "4" = [ ];
            "5" = [ ];
          };
        };

        mpris = {
          interval = 1;
          format = "{player_icon} {status_icon} {dynamic}";
          format-paused = "{player_icon} {status_icon} <i>{dynamic}</i>";
          format-stopped = "";
          tooltip-format = "{player_icon} {status_icon}\n{dynamic}\nLength: {length}";
          player-icons = {
            default = "♪";
            spotify_player = "󰓇";
          };
          status-icons = {
            paused = "󰏤";
            playing = "󰐊";
            stopped = "󰙦";
          };
          dynamic-len = 30;
          dynamic-order = [ "title" "artist" ];
          dynamic-separator = " - ";
          on-click = "playerctl play-pause";
          on-click-right = "playerctl next";
          on-click-middle = "playerctl previous";
        };
        clock = {
          format = "{:%A %d %B - %I:%M%p}";
          format-alt = "{:%d %B W%V %Y}";
          tooltip = false;
        };
        network = {
          format-icons = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
          format = "{icon}";
          format-wifi = "{icon}";
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
            warning = 25;
            critical = 15;
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
          interval = 4;
          format = "M{percentage:>02}%";
          tooltip = true;
          tooltip-format = "Memory: {used:0.1f}GB / {total:0.1f}GB\nSwap: {swapUsed:0.1f}GB / {swapTotal:0.1f}GB";
        };
        cpu = {
          interval = 2;
          format = "C{usage:>02}%";
          on-click-right = "${terminal} -e btop";
          tooltip = true;
          tooltip-format = "CPU: {usage}%\nLoad: {load}";
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
          exec = "${./waybar/waybar-dropbox}";
          on-click = "${terminal} -e yazi ~/Dropbox";
          interval = 5;
          tooltip = true;
        };
        "custom/tailscale" = {
          format = "{text}";
          return-type = "json";
          exec = "${./waybar/waybar-tailscale}";
          on-click = "tailscale ip -4 | wl-copy";
          on-click-right = "tailscale ip -6 | wl-copy";
          interval = 5;
          tooltip = true;
        };

        "custom/terminals" = {
          format = "{text}";
          return-type = "json";
          exec = "${./waybar/waybar-count-terms}";
          interval = 5;
          tooltip = true;
        };
      }
    ];
  };
}
