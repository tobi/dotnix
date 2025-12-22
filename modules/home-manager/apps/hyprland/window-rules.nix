{ config, lib, ... }:
{
  config = lib.mkIf (config.dotnix.wm == "hyprland") {
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
      "opacity 0.97 0.75, class:.*"

      # Opaque for media apps
      "opacity 1 1, class:^(vlc)$"
      "opacity 1 1, class:^(mpv)$"
      "opacity 1 1, title:^(Picture-in-Picture)$"

      # Browsers:

      "tag +chromium-based-browser, class:((google-)?[cC]hrom(e|ium)|[bB]rave-browser|Microsoft-edge|Vivaldi-stable|helium)"
      "tag +firefox-based-browser, class:([fF]irefox|zen|librewolf)"
      
      "opacity 1.0 1.0, initialTitle:((?i)(?:[a-z0-9-]+\\.)*youtube\\.com_/|app\\.zoom\\.us_/wc/home)"      

      "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
    ];

    windowrulev2 = [
      # Chrome/Chromium window management
      "tile, class:^(google-chrome)$"
      "tile, class:^(chromium)$"

      # Google Meet full width
      "size 99%, class:^(chrome-meet.google.com__-Default)$"
      "opacity 1 1, class:^(chrome-meet.google.com__-Default)$"

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
  };
}
