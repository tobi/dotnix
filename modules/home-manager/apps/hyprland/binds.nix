{ config, lib, ... }:

let
  binDir = "${../../../../bin}";

  # Convert niri-style key (e.g., "Super+B") to Hyprland format (e.g., "$mod, B")
  convertKey = key:
    let
      parts = lib.splitString "+" key;
      modifiers = lib.init parts;
      actualKey = lib.last parts;

      # Convert modifier names
      convertMod = mod:
        if mod == "Super" then "$mod"
        else if mod == "Shift" then "SHIFT"
        else if mod == "Alt" then "ALT"
        else if mod == "Ctrl" then "CTRL"
        else mod;

      convertedMods = map convertMod modifiers;
      modString = lib.concatStringsSep " " convertedMods;
    in
    "${modString}, ${actualKey}";

  # Generate hotkey bindings from registered apps
  # Converts dotnix.desktop.hotkeys to Hyprland bind format
  generateHotkeyBinds = hotkeys:
    lib.mapAttrsToList
      (key: cfg:
        let
          command =
            if cfg.focusClass != null then
              "${binDir}/open-or-focus ${cfg.focusClass} ${cfg.executable}"
            else
              "${binDir}/open ${cfg.executable}";
          hyprKey = convertKey key;
        in
        "${hyprKey}, exec, ${command}"
      )
      hotkeys;
in
{
  wayland.windowManager.hyprland.settings = {
    # Convert modifier keys
    "$mod" = "SUPER";

    # Application shortcuts from registered hotkeys
    bind = generateHotkeyBinds config.dotnix.desktop.hotkeys ++ [
      # ============================================================================
      # System & Utility
      # ============================================================================

      "$mod, Return, exec, ghostty"
      "$mod ALT, L, exec, hyprlock"
      "$mod, D, exec, ${binDir}/dotnix-find-windows"
      "ALT, SPACE, exec, walker"

      # ============================================================================
      # Universal Clipboard (Super+C/V/X)
      # ============================================================================

      "$mod, C, sendshortcut, CTRL, Insert,"
      "$mod, V, sendshortcut, SHIFT, Insert,"
      "$mod, X, sendshortcut, CTRL, X,"

      # ============================================================================
      # Window Management
      # ============================================================================

      "$mod, Q, killactive"
      "$mod, F, fullscreen, 0"
      "$mod SHIFT, F, togglefloating"
      "$mod, P, pseudo"
      "$mod, J, togglesplit"
      "$mod, M, exec, hyprctl keyword general:layout master"
      "$mod SHIFT, M, exec, hyprctl keyword general:layout dwindle"

      # Navigation - Arrow keys
      "$mod, left, movefocus, l"
      "$mod, right, movefocus, r"
      "$mod, up, movefocus, u"
      "$mod, down, movefocus, d"

      # Swap windows (like omarchy)
      "$mod SHIFT, left, swapwindow, l"
      "$mod SHIFT, right, swapwindow, r"
      "$mod SHIFT, up, swapwindow, u"
      "$mod SHIFT, down, swapwindow, d"

      # Merge windows into groups
      "$mod CTRL, left, moveintogroup, l"
      "$mod CTRL, right, moveintogroup, r"
      "$mod CTRL, up, moveintogroup, u"
      "$mod CTRL, down, moveintogroup, d"

      # Resize active window (like omarchy)
      "$mod, minus, resizeactive, -100 0"
      "$mod, equal, resizeactive, 100 0"
      "$mod SHIFT, minus, resizeactive, 0 -100"
      "$mod SHIFT, equal, resizeactive, 0 100"

      # ============================================================================
      # Workspace Management
      # ============================================================================

      # Switch workspaces
      "$mod, 1, workspace, 1"
      "$mod, 2, workspace, 2"
      "$mod, 3, workspace, 3"
      "$mod, 4, workspace, 4"
      "$mod, 5, workspace, 5"
      "$mod, 6, workspace, 6"
      "$mod, 7, workspace, 7"
      "$mod, 8, workspace, 8"
      "$mod, 9, workspace, 9"
      "$mod, 0, workspace, 10"

      # Move window to workspace
      "$mod SHIFT, 1, movetoworkspace, 1"
      "$mod SHIFT, 2, movetoworkspace, 2"
      "$mod SHIFT, 3, movetoworkspace, 3"
      "$mod SHIFT, 4, movetoworkspace, 4"
      "$mod SHIFT, 5, movetoworkspace, 5"
      "$mod SHIFT, 6, movetoworkspace, 6"
      "$mod SHIFT, 7, movetoworkspace, 7"
      "$mod SHIFT, 8, movetoworkspace, 8"
      "$mod SHIFT, 9, movetoworkspace, 9"
      "$mod SHIFT, 0, movetoworkspace, 10"

      # Workspace navigation
      "$mod, Page_Down, workspace, e+1"
      "$mod, Page_Up, workspace, e-1"
      "$mod CTRL, down, workspace, e+1"
      "$mod CTRL, up, workspace, e-1"

      # Move window to next/previous workspace
      "$mod SHIFT, Page_Down, movetoworkspace, e+1"
      "$mod SHIFT, Page_Up, movetoworkspace, e-1"
      "$mod CTRL SHIFT, down, movetoworkspace, e+1"
      "$mod CTRL SHIFT, up, movetoworkspace, e-1"

      # Special workspace (scratchpad)
      "$mod, tilde, togglespecialworkspace, magic"
      "$mod SHIFT, tilde, movetoworkspace, special:magic"

      # ============================================================================
      # Monitor Management
      # ============================================================================

      "$mod SHIFT, bracketleft, focusmonitor, l"
      "$mod SHIFT, bracketright, focusmonitor, r"
      "$mod CTRL SHIFT, bracketleft, movewindow, mon:l"
      "$mod CTRL SHIFT, bracketright, movewindow, mon:r"

      # ============================================================================
      # Session Management
      # ============================================================================

      "$mod SHIFT, R, exec, hyprctl reload"
      "CTRL ALT, Delete, exit"
    ];

    # Repeatable bindings for volume and brightness
    bindel = [
      ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
      ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
    ];

    # Non-repeatable bindings for media control
    bindl = [
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPrev, exec, playerctl previous"
    ];

    # Mouse bindings
    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];
  };
}
