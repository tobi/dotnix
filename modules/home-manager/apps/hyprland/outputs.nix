_:

{
  wayland.windowManager.hyprland.settings = {
    monitor = [
      # Apple StudioDisplay (5K - main display) - listed first for workspace preference
      "desc:Apple Computer Inc StudioDisplay 0xA15CA633,5120x2880@60,auto,2"

      # Built-in laptop display (Framework 13.5") - always on left
      "eDP-1,preferred,0x0,1.6"

      # Disable DP-6 (duplicate/unwanted output)
      "DP-6,disable"

      # Disable unknown monitors
      "Unknown Unknown Unknown,disable"

      # Auto-configure any other monitors
      ",preferred,auto,1.66666"
    ];

    # Turn off laptop display when lid is closed
    bindl = [
      ", switch:on:Lid Switch, exec, hyprctl keyword monitor 'eDP-1,disable'"
      ", switch:off:Lid Switch, exec, hyprctl keyword monitor 'eDP-1,preferred,0x0,1.6'"
    ];
  };
}
