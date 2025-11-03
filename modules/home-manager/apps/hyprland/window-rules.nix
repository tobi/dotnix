_:

{
  wayland.windowManager.hyprland.settings = {
    windowrule = [
      # Suppress maximize events (Hyprland uses tiling)
      "suppressevent maximize, class:.*"

      # Float file pickers
      "float, title:^(Open)$"
      "float, title:^(Save)$"
      "float, class:^(xdg-desktop-portal-gtk)$"

      # Float utility windows
      "float, class:^(pavucontrol)$"
      "float, class:^(blueberry.py)$"
      "float, class:^(nm-connection-editor)$"

      # Transparency for most windows
      "opacity 0.97 0.9, class:.*"

      # Opaque for media apps
      "opacity 1 1, class:^(vlc)$"
      "opacity 1 1, class:^(mpv)$"
      "opacity 1 1, title:^(Picture-in-Picture)$"
    ];

    windowrulev2 = [
      # Chrome/Chromium window management
      "tile, class:^(google-chrome)$"
      "tile, class:^(chromium)$"

      # Google Meet full width
      "size 99%, class:^(chrome-meet.google.com__-Default)$"

      # Picture-in-Picture always on top
      "float, title:^(Picture-in-Picture)$"
      "pin, title:^(Picture-in-Picture)$"
      "size 25% 25%, title:^(Picture-in-Picture)$"
      "move 74% 74%, title:^(Picture-in-Picture)$"
    ];

    layerrule = [
      "blur, waybar"
      "blur, walker"
      "blur, notifications"
    ];
  };
}
