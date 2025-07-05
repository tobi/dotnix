{ config, palette, ... }: {
  # Input device configuration
  input = {
    keyboard = {
      xkb = {
        options = "caps:super";
      };
      repeat-delay = 400;
      repeat-rate = 40;
      numlock = true;
    };

    touchpad = {
      tap = true;
      dwt = true;
      accel-profile = "flat";
      scroll-factor = 0.5;
      natural-scroll = false;
    };

    mouse = {
      accel-profile = "flat";
    };

    warp-mouse-to-focus = {
      enable = true;
    };

    focus-follows-mouse = {
      max-scroll-amount = "0%";
    };
  };

  # Layout configuration
  layout = {
    gaps = 20;
    center-focused-column = "never";

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
      width = 3;
      inactive = {
        gradient = {
          from = "#${palette.base03}";
          to = "#${palette.base02}";
          angle = 45;
          relative-to = "workspace-view";
        };
      };
      active = {
        gradient = {
          from = "#${palette.base0B}";
          to = "#${palette.base0D}";
          angle = 45;
          relative-to = "workspace-view";
        };
      };
    };

    border = {
      enable = false;
    };

    shadow = {
      enable = true;
      softness = 30;
      spread = 3;
      offset = {
        x = 3;
        y = 3;
      };
    };
  };

  # Environment variables
  environment = {
    NIXOS_OZONE_WL = "1";
  };

  # Startup applications
  spawn-at-startup = [
    { command = [ "waybar" ]; }
    { command = [ "xwayland-satellite" ]; }
    { command = [ "alacritty" ]; }
    { command = [ "wbg" "${../wallpaper.jpg}" ]; }
  ];

  prefer-no-csd = true;

  screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";


  # Output configurations
  outputs = {
    "eDP-1" = {
      scale = 1.5;
      position = {
        x = 0;
        y = 0;
      };
    };
    "Apple Computer Inc StudioDisplay 0x47040065" = {
      scale = 1.8;
      focus-at-startup = true;
      background-color = "#${palette.base01}";
    };
  };

  # Cursor configuration
  cursor = {
    theme = "capitaine-cursors";
    size = 26;
    hide-when-typing = true;
  };


  # Animations
  animations = {
    slowdown = 1.2;

    workspace-switch.kind = {
      spring = {
        damping-ratio = 0.7;
        stiffness = 1200;
        epsilon = 0.0001;
      };
    };

    window-open.kind = {
      easing = {
        duration-ms = 350;
        curve = "ease-out-expo";
      };
    };

    window-close.kind = {
      easing = {
        duration-ms = 250;
        curve = "ease-out-cubic";
      };
    };

    horizontal-view-movement.kind = {
      spring = {
        damping-ratio = 0.8;
        stiffness = 1000;
        epsilon = 0.0005;
      };
    };

    window-movement.kind = {
      spring = {
        damping-ratio = 0.75;
        stiffness = 900;
        epsilon = 0.0001;
      };
    };

    window-resize.kind = {
      spring = {
        damping-ratio = 0.8;
        stiffness = 1100;
        epsilon = 0.0001;
      };
    };

    config-notification-open-close.kind = {
      spring = {
        damping-ratio = 0.5;
        stiffness = 1200;
        epsilon = 0.001;
      };
    };

    screenshot-ui-open.kind = {
      easing = {
        duration-ms = 300;
        curve = "ease-out-cubic";
      };
    };

    overview-open-close.kind = {
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
      matches = [{ app-id = "^com\\.mitchellh\\.ghostty$"; }];
      default-column-width = { fixed = 700; };
    }
    {
      matches = [{ app-id = "^Alacritty$"; }];
      default-column-width = { fixed = 700; };
    }
    {
      matches = [
        { app-id = "^xdg-desktop-portal-gtk$"; }
        { title = "^Open"; }
      ];
      open-floating = true;
    }
    {
      matches = [
        { app-id = "firefox$"; }
        { title = "^Picture-in-Picture$"; }
      ];
      open-floating = true;
    }
    {
      geometry-corner-radius = {
        top-left = 14.0;
        top-right = 14.0;
        bottom-left = 14.0;
        bottom-right = 14.0;
      };
      clip-to-geometry = true;
    }
  ];

  # Switch events
  switch-events = {
    lid-close.action.spawn = [ "notify-send" "The laptop lid is closed!" ];
    lid-open.action.spawn = [ "notify-send" "The laptop lid is open!" ];
  };

  # Key bindings using proper niri actions
  binds = with config.lib.niri.actions; {
    # Show hotkey overlay
    "Mod+Shift+Slash".action = show-hotkey-overlay;

    # Application launchers
    "Mod+T" = {
      action = spawn "ghostty";
      hotkey-overlay.title = "Open a Terminal: ghostty";
    };
    "Mod+D" = {
      action = spawn "fuzzel";
      hotkey-overlay.title = "Run an Application: fuzzel";
    };
    "Super+Alt+L" = {
      action = spawn "swaylock";
      hotkey-overlay.title = "Lock the Screen: swaylock";
    };

    # Media keys
    "XF86AudioRaiseVolume" = {
      action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+";
      allow-when-locked = true;
    };
    "XF86AudioLowerVolume" = {
      action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-";
      allow-when-locked = true;
    };
    "XF86AudioMute" = {
      action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
      allow-when-locked = true;
    };
    "XF86AudioMicMute" = {
      action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle";
      allow-when-locked = true;
    };

    # Brightness keys
    "XF86MonBrightnessDown" = {
      action = spawn "brightnessctl" "set" "5%-";
      allow-when-locked = true;
    };
    "XF86MonBrightnessUp" = {
      action = spawn "brightnessctl" "set" "5%+";
      allow-when-locked = true;
    };

    # Window management
    "Mod+O" = {
      action = toggle-overview;
      repeat = false;
    };
    "Mod+Q".action = close-window;
    "Mod+W".action = close-window;

    # Focus navigation
    "Mod+Left".action = focus-column-left;
    "Mod+Down".action = focus-window-down;
    "Mod+Up".action = focus-window-up;
    "Mod+Right".action = focus-column-right;
    "Mod+H".action = focus-column-left;
    "Mod+J".action = focus-window-down;
    "Mod+K".action = focus-window-up;
    "Mod+L".action = focus-column-right;

    # Move windows
    "Mod+Ctrl+Left".action = move-column-left;
    "Mod+Ctrl+Down".action = move-window-down;
    "Mod+Ctrl+Up".action = move-window-up;
    "Mod+Ctrl+Right".action = move-column-right;
    "Mod+Ctrl+H".action = move-column-left;
    "Mod+Ctrl+J".action = move-window-down;
    "Mod+Ctrl+K".action = move-window-up;
    "Mod+Ctrl+L".action = move-column-right;


    # Additional workspace navigation
    "Mod+Page_Down".action = focus-workspace-down;
    "Mod+Page_Up".action = focus-workspace-up;
    "Mod+Shift+Down".action = focus-workspace-down;
    "Mod+Shift+Up".action = focus-workspace-up;
    "Mod+Shift+Ctrl+Down".action = move-workspace-down;
    "Mod+Shift+Ctrl+Up".action = move-workspace-up;

    # Workspace movement (using relative movements)
    "Mod+U".action = focus-workspace-down;
    "Mod+I".action = focus-workspace-up;
    "Mod+Ctrl+Page_Down".action = move-column-to-workspace-down;
    "Mod+Ctrl+Page_Up".action = move-column-to-workspace-up;
    "Mod+Ctrl+U".action = move-column-to-workspace-down;
    "Mod+Ctrl+I".action = move-column-to-workspace-up;
    "Mod+Shift+Page_Down".action = move-workspace-down;
    "Mod+Shift+Page_Up".action = move-workspace-up;
    "Mod+Shift+U".action = move-workspace-down;
    "Mod+Shift+I".action = move-workspace-up;

    # Quick apps
    "Alt+Space".action = spawn "fuzzel";
    "Super+Shift+Return".action = spawn "ghostty";
    "Super+Return".action = spawn "alacritty";
    "Super+X".action = spawn "${config.home.homeDirectory}/dotnix/home/bin/open" "cursor";
    "Super+C".action = spawn "${config.home.homeDirectory}/dotnix/home/bin/open" "google-chrome";
    "Super+A".action = spawn "${config.home.homeDirectory}/dotnix/home/bin/open" "chatgpt";

    # Additional navigation
    "Mod+Home".action = focus-column-first;
    "Mod+End".action = focus-column-last;
    "Mod+Ctrl+Home".action = move-column-to-first;
    "Mod+Ctrl+End".action = move-column-to-last;

    # Monitor focus
    "Mod+Shift+BracketLeft".action = focus-monitor-left;
    "Mod+Shift+BracketRight".action = focus-monitor-right;
    "Mod+Shift+Ctrl+BracketLeft".action = move-column-to-monitor-left;
    "Mod+Shift+Ctrl+BracketRight".action = move-column-to-monitor-right;

    # Mouse wheel bindings
    "Mod+WheelScrollDown" = {
      action = focus-workspace-down;
      cooldown-ms = 150;
    };
    "Mod+WheelScrollUp" = {
      action = focus-workspace-up;
      cooldown-ms = 150;
    };
    "Mod+Ctrl+WheelScrollDown" = {
      action = move-column-to-workspace-down;
      cooldown-ms = 150;
    };
    "Mod+Ctrl+WheelScrollUp" = {
      action = move-column-to-workspace-up;
      cooldown-ms = 150;
    };
    "Mod+WheelScrollRight".action = focus-column-right;
    "Mod+WheelScrollLeft".action = focus-column-left;
    "Mod+Ctrl+WheelScrollRight".action = move-column-right;
    "Mod+Ctrl+WheelScrollLeft".action = move-column-left;
    "Mod+Shift+WheelScrollDown".action = focus-column-right;
    "Mod+Shift+WheelScrollUp".action = focus-column-left;
    "Mod+Ctrl+Shift+WheelScrollDown".action = move-column-right;
    "Mod+Ctrl+Shift+WheelScrollUp".action = move-column-left;

    # Layout controls
    "Mod+Tab".action = focus-workspace-previous;
    "Mod+BracketLeft".action = consume-or-expel-window-left;
    "Mod+BracketRight".action = consume-or-expel-window-right;
    "Mod+R".action = switch-preset-column-width;
    "Mod+Shift+R".action = switch-preset-window-height;
    "Mod+Ctrl+R".action = reset-window-height;
    "Mod+F".action = maximize-column;
    "Mod+Shift+F".action = fullscreen-window;
    "Mod+Ctrl+F".action = expand-column-to-available-width;
    "Mod+V".action = toggle-window-floating;
    "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;
    "Super+Comma".action = center-visible-columns;

    # Column width adjustment
    "Mod+Minus".action = (set-column-width "-10%");
    "Mod+Equal".action = (set-column-width "+10%");

    # Window height adjustment
    "Mod+Shift+Minus".action = (set-window-height "-10%");
    "Mod+Shift+Equal".action = (set-window-height "+10%");

    # Screenshots
    "F12".action = screenshot;
    "Mod+F12".action = screenshot-window;
    "Print".action = screenshot;
    "Ctrl+Print".action = screenshot;
    "Alt+Print".action = screenshot;

    # System
    "Mod+Escape" = {
      action = toggle-keyboard-shortcuts-inhibit;
      allow-inhibiting = false;
    };
    "Mod+Shift+E".action = quit;
    "Ctrl+Alt+Delete".action = quit;
    "Mod+Shift+P".action = power-off-monitors;


    "Super+1".action = focus-workspace 1;
    "Super+2".action = focus-workspace 2;
    "Super+3".action = focus-workspace 3;

    # "Mod+Ctrl+1".action = move-column-to-workspace 1;
    # "Mod+Ctrl+2".action = move-column-to-workspace 2;
    # "Mod+Ctrl+3".action = move-column-to-workspace 3;

    # "Super+Ctrl+1".action = move-column-to-workspace 1;
    #   action = move-column-to-workspace 1;
    # };
    # "Super+Ctrl+2" = {
    #   action = move-column-to-workspace 2;
    # };
    # "Super+Ctrl+3" = {
    #   action = move-column-to-workspace 3;
    # };


    # "Super+2".action = (focus-workspace 2);
    # "Super+3".action = (focus-workspace 3);

    # "Super+Ctrl+1".action = (move-column-to-workspace {1});
    # "Super+Ctrl+2".action = (move-column-to-workspace {2});
    # "Super+Ctrl+3".action = (move-column-to-workspace {3});
  };
};
