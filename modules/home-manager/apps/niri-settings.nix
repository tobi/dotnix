{ config, lib, pkgs, theme, ... }:

{
  # Nix-native configuration for niri using sodiboo/niri-flake
  # This generates the config.kdl file from structured Nix settings
  programs.niri.settings = {
    # Input configuration
    input = {
      keyboard = {
        xkb = {
          options = "caps:super";
        };
        repeat-delay = 400;
        repeat-rate = 40;
        track-layout = "window";
      };

      touchpad = {
        tap = true;
        dwt = true;
        accel-profile = "flat";
        click-method = "clickfinger";
        scroll-factor = 0.5;
      };

      mouse = {
        accel-profile = "flat";
      };

      warp-mouse-to-focus = true;
      focus-follows-mouse = {
        enable = true;
        max-scroll-amount = "0%";
      };
    };

    # Overview configuration
    overview = {
      workspace-shadow.off = true;
    };

    # Output configuration
    outputs."eDP-1" = {
      scale = 1.5;
      transform = "normal";
      position = {
        x = 0;
        y = 0;
      };
    };

    outputs."Apple Computer Inc StudioDisplay 0x47040065" = {
      scale = 1.8;
      focus-at-startup = true;
    };

    # Layout configuration
    layout = {
      gaps = 15;
      center-focused-column = "never";
      background-color = "transparent";

      preset-column-widths = [
        { proportion = 0.33333; }
        { proportion = 0.5; }
        { proportion = 0.66667; }
      ];

      default-column-width = {
        proportion = 0.5;
      };

      focus-ring = {
        enable = true;
        width = 1;
        inactive-color = "#505050";
        active-gradient = {
          from = "teal";
          to = "purple";
          angle = 90;
        };
        inactive-gradient = {
          from = "#505050";
          to = "#808080";
          angle = 45;
          relative-to = "workspace-view";
        };
      };

      border = {
        enable = false;
        width = 3;
        active-color = "#ffc87f";
        inactive-color = "#505050";
        urgent-color = "#9b0000";
      };

      shadow = {
        enable = true;
        softness = 30.0;
        spread = 3.0;
        offset = {
          x = 3;
          y = 3;
        };
        color = "#000000";
      };

      struts = {};
    };

    environment = {};

    # Cursor configuration
    cursor = {
      xcursor-theme = "capitaine-cursors";
      xcursor-size = 26;
      hide-when-typing = true;
    };

    # Spawn at startup
    spawn-at-startup = [
      { command = [ "swaylock" ]; }
      { command = [ "waybar" ]; }
      { command = [ "wbg" ".config/wallpaper.jpg" ]; }
      { command = [ "ghostty" ]; }
      { command = [ "sway-audio-idle-inhibit" ]; }
    ];

    prefer-no-csd = true;

    hotkey-overlay = {
      skip-at-startup = true;
    };

    screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

    # Animations
    animations = {
      slowdown = 1.2;

      workspace-switch = {
        spring = {
          damping-ratio = 0.7;
          stiffness = 1200;
          epsilon = 0.0001;
        };
      };

      window-open = {
        duration-ms = 350;
        curve = "ease-out-expo";
      };

      window-close = {
        duration-ms = 250;
        curve = "ease-out-cubic";
      };

      horizontal-view-movement = {
        spring = {
          damping-ratio = 0.8;
          stiffness = 1000;
          epsilon = 0.0001;
        };
      };

      window-movement = {
        spring = {
          damping-ratio = 0.75;
          stiffness = 900;
          epsilon = 0.0001;
        };
      };

      window-resize = {
        spring = {
          damping-ratio = 0.8;
          stiffness = 1100;
          epsilon = 0.0001;
        };
      };

      config-notification-open-close = {
        spring = {
          damping-ratio = 0.5;
          stiffness = 1200;
          epsilon = 0.001;
        };
      };

      screenshot-ui-open = {
        duration-ms = 300;
        curve = "ease-out-cubic";
      };

      overview-open-close = {
        spring = {
          damping-ratio = 0.75;
          stiffness = 1000;
          epsilon = 0.0001;
        };
      };
    };

    # Window rules
    window-rules = [
      {
        matches = [
          { app-id = "^xdg-desktop-portal-gtk$"; }
          { title = "^Open"; }
        ];
        open-floating = true;
        max-width = 1000;
        max-height = 1000;
      }
      {
        matches = [
          { title = "^google-chrome$"; }
        ];
      }
      {
        matches = [
          { app-id = "firefox$"; title = "^Picture-in-Picture$"; }
        ];
        open-floating = true;
      }
      {
        geometry-corner-radius = 14.0;
        clip-to-geometry = true;
      }
    ];

    # Layer rules
    layer-rules = [
      {
        matches = [
          { namespace = "^wallpaper$"; }
        ];
        place-within-backdrop = true;
      }
    ];

    # Switch events
    switch-events = {
      lid-close = {
        action.spawn = [ "systemctl" "suspend" ];
      };
    };

    # Keybindings
    binds = {
      "Mod+Shift+Slash".action.show-hotkey-overlay = {};

      "Mod+T" = {
        action.spawn = [ "ghostty" ];
        hotkey-overlay-title = "Open a Terminal: ghostty";
      };
      "Mod+D" = {
        action.spawn = [ "fuzzel" ];
        hotkey-overlay-title = "Run an Application: fuzzel";
      };
      "Super+Alt+L" = {
        action.spawn = [ "swaylock" ];
        hotkey-overlay-title = "Lock the Screen: swaylock";
      };

      # Volume keys
      "XF86AudioRaiseVolume" = {
        action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+" ];
        allow-when-locked = true;
      };
      "XF86AudioLowerVolume" = {
        action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-" ];
        allow-when-locked = true;
      };
      "XF86AudioMute" = {
        action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle" ];
        allow-when-locked = true;
      };
      "XF86AudioMicMute" = {
        action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle" ];
        allow-when-locked = true;
      };

      "XF86MonBrightnessDown" = {
        action.spawn = [ "brightnessctl" "set" "5%-" ];
        allow-when-locked = true;
      };
      "XF86MonBrightnessUp" = {
        action.spawn = [ "brightnessctl" "set" "5%+" ];
        allow-when-locked = true;
      };

      "Mod+O" = {
        action.toggle-overview = {};
        repeat = false;
      };

      "Mod+Q".action.close-window = {};

      # Navigation
      "Mod+Left".action.focus-column-left = {};
      "Mod+Down".action.focus-window-down = {};
      "Mod+Up".action.focus-window-up = {};
      "Mod+Right".action.focus-column-right = {};
      "Mod+H".action.focus-column-left = {};
      "Mod+J".action.focus-window-down = {};
      "Mod+K".action.focus-window-up = {};
      "Mod+L".action.focus-column-right = {};

      # Move windows
      "Mod+Ctrl+Left".action.move-column-left = {};
      "Mod+Ctrl+Right".action.move-column-right = {};
      "Mod+Ctrl+Down".action.move-column-to-workspace-down = {};
      "Mod+Ctrl+Up".action.move-column-to-workspace-up = {};
      "Mod+Ctrl+H".action.move-column-left = {};
      "Mod+Ctrl+J".action.move-column-to-workspace-down = {};
      "Mod+Ctrl+K".action.move-column-to-workspace-up = {};

      "Mod+Home".action.focus-column-first = {};
      "Mod+End".action.focus-column-last = {};
      "Mod+Ctrl+Home".action.move-column-to-first = {};
      "Mod+Ctrl+End".action.move-column-to-last = {};

      # Monitor switching
      "Mod+Shift+BracketLeft".action.focus-monitor-left = {};
      "Mod+Shift+BracketRight".action.focus-monitor-right = {};

      "Mod+Shift+Ctrl+BracketLeft".action.move-column-to-monitor-left = {};
      "Mod+Shift+Ctrl+BracketRight".action.move-column-to-monitor-right = {};

      # Workspace switching
      "Mod+Page_Down".action.focus-workspace-down = {};
      "Mod+Page_Up".action.focus-workspace-up = {};
      "Mod+Shift+Down".action.focus-workspace-down = {};
      "Mod+Shift+Up".action.focus-workspace-up = {};

      "Mod+Shift+Ctrl+Down".action.move-workspace-down = {};
      "Mod+Shift+Ctrl+Up".action.move-workspace-up = {};

      "Mod+U".action.focus-workspace-down = {};
      "Mod+I".action.focus-workspace-up = {};
      "Mod+Ctrl+Page_Down".action.move-column-to-workspace-down = {};
      "Mod+Ctrl+Page_Up".action.move-column-to-workspace-up = {};
      "Mod+Ctrl+U".action.move-column-to-workspace-down = {};
      "Mod+Ctrl+I".action.move-column-to-workspace-up = {};

      # Mouse wheel workspace switching
      "Mod+WheelScrollDown" = {
        action.focus-workspace-down = {};
        cooldown-ms = 150;
      };
      "Mod+WheelScrollUp" = {
        action.focus-workspace-up = {};
        cooldown-ms = 150;
      };
      "Mod+Ctrl+WheelScrollDown" = {
        action.move-column-to-workspace-down = {};
        cooldown-ms = 150;
      };
      "Mod+Ctrl+WheelScrollUp" = {
        action.move-column-to-workspace-up = {};
        cooldown-ms = 150;
      };

      "Mod+WheelScrollRight".action.focus-column-right = {};
      "Mod+WheelScrollLeft".action.focus-column-left = {};
      "Mod+Ctrl+WheelScrollRight".action.move-column-right = {};
      "Mod+Ctrl+WheelScrollLeft".action.move-column-left = {};

      "Mod+Shift+WheelScrollDown".action.focus-column-right = {};
      "Mod+Shift+WheelScrollUp".action.focus-column-left = {};
      "Mod+Ctrl+Shift+WheelScrollDown".action.move-column-right = {};
      "Mod+Ctrl+Shift+WheelScrollUp".action.move-column-left = {};

      # Workspace switching by index
      "Mod+1".action.focus-workspace = 1;
      "Mod+2".action.focus-workspace = 2;
      "Mod+3".action.focus-workspace = 3;
      "Mod+4".action.focus-workspace = 4;
      "Mod+5".action.focus-workspace = 5;
      "Mod+6".action.focus-workspace = 6;
      "Mod+7".action.focus-workspace = 7;
      "Mod+8".action.focus-workspace = 8;
      "Mod+9".action.focus-workspace = 9;

      "Mod+Shift+1".action.move-column-to-workspace = 1;
      "Mod+Shift+2".action.move-column-to-workspace = 2;
      "Mod+Shift+3".action.move-column-to-workspace = 3;
      "Mod+Shift+4".action.move-column-to-workspace = 4;
      "Mod+Shift+5".action.move-column-to-workspace = 5;
      "Mod+Shift+6".action.move-column-to-workspace = 6;
      "Mod+Shift+7".action.move-column-to-workspace = 7;
      "Mod+Shift+8".action.move-column-to-workspace = 8;
      "Mod+Shift+9".action.move-column-to-workspace = 9;

      # Application launchers
      "Alt+Space".action.spawn = [ "fuzzel" ];
      "Super+Return".action.spawn = [ "ghostty" ];

      # Application-specific keybindings
      "Super+X".action.spawn-sh = "~/dotnix/bin/open-or-focus ~/.local/bin/cursor cursor";
      "Super+Shift+X".action.spawn-sh = "~/dotnix/bin/open cursor";
      "Super+B".action.spawn-sh = "~/dotnix/bin/open-or-focus google-chrome google-chrome";
      "Super+Shift+B".action.spawn-sh = "~/dotnix/bin/open google-chrome";
      "Super+V".action.spawn-sh = "~/dotnix/bin/open-or-focus google-chrome-shopify google-chrome";
      "Super+Shift+V".action.spawn-sh = "~/dotnix/bin/open google-chrome-shopify";
      "Super+S".action.spawn-sh = "~/dotnix/bin/open-or-focus Slack chrome-app.slack.com__-Default";
      "Super+A".action.spawn-sh = "~/dotnix/bin/open-or-focus chatgpt chrome-chat.openai.com__-Default";
      "Super+E".action.spawn-sh = "~/dotnix/bin/open-or-focus GoogleMeet chrome-meet.google.com__-Default";

      "Mod+Tab".action.focus-workspace-previous = {};

      # Window manipulation
      "Mod+BracketLeft".action.consume-or-expel-window-left = {};
      "Mod+BracketRight".action.consume-or-expel-window-right = {};

      "Mod+R".action.switch-preset-column-width = {};
      "Mod+Shift+R".action.switch-preset-window-height = {};
      "Mod+Ctrl+R".action.reset-window-height = {};
      "Mod+F".action.maximize-column = {};
      "Mod+Shift+F".action.fullscreen-window = {};
      "Mod+Ctrl+F".action.expand-column-to-available-width = {};

      "Super+Comma".action.center-visible-columns = {};

      # Resize
      "Mod+Minus".action.set-column-width = "-10%";
      "Mod+Equal".action.set-column-width = "+10%";

      "Mod+Shift+Minus".action.set-window-height = "-10%";
      "Mod+Shift+Equal".action.set-window-height = "+10%";

      # Floating windows
      "Mod+V".action.toggle-window-floating = {};
      "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = {};

      # Screenshots
      "F12".action.screenshot = {};
      "Mod+F12".action.screenshot-screen = {};
      "Print".action.screenshot = {};
      "Ctrl+Print".action.screenshot-screen = {};
      "Alt+Print".action.screenshot-window = {};

      # Exit
      "Mod+Shift+E".action.quit = {};
      "Ctrl+Alt+Delete".action.quit = {};

      "Mod+Shift+P".action.power-off-monitors = {};
    };
  };
}
