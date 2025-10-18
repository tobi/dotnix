{ config
, theme
, pkgs
, ...
}:
let
  palette = theme.palette;
  terminal = "${pkgs.ghostty}/bin/ghostty";
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
        color: #ffffff;
        text-shadow: 1px 1px 1px rgba(0, 0, 0, 0.4);
      }

      window#waybar {
        border: none;
        background: transparent;
        transition: background-color 0.5s, height 0.5s;
      }

      window#waybar.hidden {
      }

      #workspaces {
        background: transparent;
        margin: 0 5px;
        padding: 0 5px;
      }

      #workspaces button {
        padding: 0 3px;
        margin: 0 5px;
        color: #${palette.base05};
        background: transparent;
        transition: all 0.3s ease-in-out;
      }

      #workspaces button.active {
        color: #${palette.base0D};
        border-radius: 6px;
        background: rgba(0, 0, 0, 0.2);
        min-width: 40px;
      }

      #workspaces button:hover {
        color: #${palette.base0B};
        background: #${palette.base02};
      }

      .modules-left, .modules-center, .modules-right {
        background: transparent;
        margin: 0 5px;
        padding: 0 5px;
      }

      #clock, #cpu, #memory, #network, #battery, #bluetooth, #wireplumber,
      #power-profiles-daemon, #custom-dropbox, #custom-tailscale, #custom-warp,
      #custom-next-event, #mpris {
        margin: 0 5px;
        min-width: 15px;
      }

      #tray {
        margin: 0 10px;
        padding: 0 5px;
      }

      #tray > * {
        min-width: 15px;
        -gtk-icon-effect: dim;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
      }

      #cpu, #memory, #battery, #wireplumber {
        min-width: 45px;
      }

      #battery.warning:not(.charging) {
        color: yellow;
      }

      #battery.critical:not(.charging) {
        color: red;
        animation: pulse 10s ease-in-out infinite;
      }

      .muted, .disabled {
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

      #custom-warp.unknown {
        color: #${palette.base03};
      }

      #mpris {
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

      #custom-next-event {
        padding: 0 15px;
      }

      #custom-next-event.empty {
        padding: 0;
        margin: 0;
        min-width: 0;
      }

      #custom-next-event.current {
        color: #${palette.base05};
      }

      #custom-next-event.upcoming {
        color: #${palette.base05};
      }

      #custom-next-event.soon {
        color: #${palette.base0A};
      }

      #custom-next-event.now {
        color: #${palette.base08};
        animation: pulse 2s ease-in-out infinite;
      }

      #custom-next-event.error {
        color: #${palette.base08};
      }

      @keyframes pulse {
        0% { opacity: 1; }
        50% { opacity: 0.6; }
        100% { opacity: 1; }
      }

      tooltip {
        background: #${palette.base00};
        color: #${palette.base05};
        border: 1px solid #${palette.base01};
        border-radius: 6px;
        padding: 15px 10px;
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
        height = 22;
        modules-left = [
          "niri/workspaces"
          "power-profiles-daemon"
          "mpris"
        ];
        modules-center = [
          "custom/next-event"
          "clock"
        ];
        modules-right = [
          "wireplumber"
          "network"
          "bluetooth"
          "custom/tailscale"
          "custom/warp"
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
        "custom/warp" = {
          format = "{text}";
          return-type = "json";
          exec = "${./waybar/waybar-warp}";
          on-click = "warp-cli connect";
          on-click-right = "warp-cli disconnect";
          interval = 5;
          tooltip = true;
        };
        "custom/next-event" = {
          format = "󰸗 {text}";
          return-type = "json";
          exec = "${pkgs.ruby}/bin/ruby ${./waybar/waybar-next-event.rb}";
          tooltip = true;
        };

        tray = {
          icon-size = 14;
          spacing = 6;
        };

      }
    ];
  };
}

