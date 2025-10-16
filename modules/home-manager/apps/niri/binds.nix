{ config, lib, ... }:

let
  # Generate hotkey bindings from registered apps
  generateHotkeyBinds = hotkeys:
    let
      # For each hotkey, generate main bind (focus or open depending on focusClass)
      mainBinds = lib.mapAttrs'
        (key: cfg:
          lib.nameValuePair key {
            action.spawn =
              if cfg.focusClass != null
              then [
                "~/dotnix/bin/open-or-focus"
                cfg.executable
                cfg.focusClass
              ]
              else [
                "~/dotnix/bin/open"
                cfg.executable
              ];
          }
        )
        hotkeys;

      # For each hotkey, generate open bind (with Shift) - always forces new instance
      openBinds = lib.mapAttrs'
        (key: cfg:
          let
            # Convert "Super+X" to "Super+Shift+X"
            shiftKey = lib.replaceStrings [ "Super+" ] [ "Super+Shift+" ] key;
          in
          lib.nameValuePair shiftKey {
            action.spawn = [
              "~/dotnix/bin/open"
              cfg.executable
            ];
          }
        )
        hotkeys;
    in
    mainBinds // openBinds;
in
{
  programs.niri.settings.binds = (generateHotkeyBinds config.dotnix.desktop.hotkeys) // {
    # ============================================================================
    # System & Utility
    # ============================================================================

    "Mod+D" = {
      action.spawn = [ "fuzzel" ];
      hotkey-overlay.title = "Run an Application: fuzzel";
    };

    "Super+Alt+L" = {
      action.spawn = [ "swaylock" ];
      hotkey-overlay.title = "Lock the Screen: swaylock";
    };

    # ============================================================================
    # Media Keys
    # ============================================================================

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

    # ============================================================================
    # Window Management
    # ============================================================================

    "Mod+O" = {
      action.toggle-overview = { };
      repeat = false;
    };

    "Mod+Q".action.close-window = { };

    # Navigation - Arrow keys
    "Mod+Left".action.focus-column-left = { };
    "Mod+Down".action.focus-window-down = { };
    "Mod+Up".action.focus-window-up = { };
    "Mod+Right".action.focus-column-right = { };

    # Navigation - Vim keys
    "Mod+H".action.focus-column-left = { };
    "Mod+J".action.focus-window-down = { };
    "Mod+K".action.focus-window-up = { };
    "Mod+L".action.focus-column-right = { };

    # Move windows
    "Mod+Ctrl+Left".action.move-column-left = { };
    "Mod+Ctrl+Right".action.move-column-right = { };
    "Mod+Ctrl+Down".action.move-column-to-workspace-down = { };
    "Mod+Ctrl+Up".action.move-column-to-workspace-up = { };
    "Mod+Ctrl+H".action.move-column-left = { };
    "Mod+Ctrl+J".action.move-column-to-workspace-down = { };
    "Mod+Ctrl+K".action.move-column-to-workspace-up = { };

    "Mod+Home".action.focus-column-first = { };
    "Mod+End".action.focus-column-last = { };
    "Mod+Ctrl+Home".action.move-column-to-first = { };
    "Mod+Ctrl+End".action.move-column-to-last = { };

    # ============================================================================
    # Monitor Management
    # ============================================================================

    "Mod+Shift+BracketLeft".action.focus-monitor-left = { };
    "Mod+Shift+BracketRight".action.focus-monitor-right = { };

    "Mod+Shift+Ctrl+BracketLeft".action.move-column-to-monitor-left = { };
    "Mod+Shift+Ctrl+BracketRight".action.move-column-to-monitor-right = { };

    # ============================================================================
    # Workspace Management
    # ============================================================================

    "Mod+Page_Down".action.focus-workspace-down = { };
    "Mod+Page_Up".action.focus-workspace-up = { };
    "Mod+Shift+Down".action.focus-workspace-down = { };
    "Mod+Shift+Up".action.focus-workspace-up = { };

    "Mod+Shift+Ctrl+Down".action.move-workspace-down = { };
    "Mod+Shift+Ctrl+Up".action.move-workspace-up = { };

    "Mod+U".action.focus-workspace-down = { };
    "Mod+I".action.focus-workspace-up = { };
    "Mod+Ctrl+Page_Down".action.move-column-to-workspace-down = { };
    "Mod+Ctrl+Page_Up".action.move-column-to-workspace-up = { };
    "Mod+Ctrl+U".action.move-column-to-workspace-down = { };
    "Mod+Ctrl+I".action.move-column-to-workspace-up = { };

    # Mouse wheel workspace switching
    "Mod+WheelScrollDown" = {
      action.focus-workspace-down = { };
      cooldown-ms = 150;
    };
    "Mod+WheelScrollUp" = {
      action.focus-workspace-up = { };
      cooldown-ms = 150;
    };
    "Mod+Ctrl+WheelScrollDown" = {
      action.move-column-to-workspace-down = { };
      cooldown-ms = 150;
    };
    "Mod+Ctrl+WheelScrollUp" = {
      action.move-column-to-workspace-up = { };
      cooldown-ms = 150;
    };

    "Mod+WheelScrollRight".action.focus-column-right = { };
    "Mod+WheelScrollLeft".action.focus-column-left = { };
    "Mod+Ctrl+WheelScrollRight".action.move-column-right = { };
    "Mod+Ctrl+WheelScrollLeft".action.move-column-left = { };

    "Mod+Shift+WheelScrollDown".action.focus-column-right = { };
    "Mod+Shift+WheelScrollUp".action.focus-column-left = { };
    "Mod+Ctrl+Shift+WheelScrollDown".action.move-column-right = { };
    "Mod+Ctrl+Shift+WheelScrollUp".action.move-column-left = { };

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

    # ============================================================================
    # Application Launchers
    # ============================================================================

    "Alt+Space".action.spawn = [ "fuzzel" ];
    "Super+Return".action.spawn = [ "ghostty" ];

    # Application-specific keybindings are now registered in individual app modules
    # via dotnix.desktop.hotkeys and generated above

    "Mod+Tab".action.focus-workspace-previous = { };

    # ============================================================================
    # Window Layout & Sizing
    # ============================================================================

    "Mod+BracketLeft".action.consume-or-expel-window-left = { };
    "Mod+BracketRight".action.consume-or-expel-window-right = { };

    "Mod+R".action.switch-preset-column-width = { };
    "Mod+Shift+R".action.switch-preset-window-height = { };
    "Mod+Ctrl+R".action.reset-window-height = { };
    "Mod+F".action.maximize-column = { };
    "Mod+Shift+F".action.fullscreen-window = { };
    "Mod+Ctrl+F".action.expand-column-to-available-width = { };

    "Super+Comma".action.center-visible-columns = { };

    # Resize
    "Mod+Minus".action.set-column-width = "-10%";
    "Mod+Equal".action.set-column-width = "+10%";

    "Mod+Shift+Minus".action.set-window-height = "-10%";
    "Mod+Shift+Equal".action.set-window-height = "+10%";

    # Floating windows
    "Mod+V".action.toggle-window-floating = { };
    "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = { };

    # ============================================================================
    # Screenshots
    # ============================================================================

    "F12".action.screenshot = { };
    "Mod+F12".action.screenshot-screen = { };
    "Print".action.screenshot = { };
    "Ctrl+Print".action.screenshot-screen = { };
    "Alt+Print".action.screenshot-window = { };

    # ============================================================================
    # Session Management
    # ============================================================================

    "Mod+Shift+E".action.quit = { };
    "Ctrl+Alt+Delete".action.quit = { };

    "Mod+Shift+P".action.power-off-monitors = { };
  };
}
