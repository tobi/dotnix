_:

{
  wayland.windowManager.hyprland.settings = {
    monitor = [
      # Built-in laptop display
      "eDP-1,preferred,0x0,1.6"

      # Apple ProDisplayXDR - 6K display
      "desc:Apple Computer Inc ProDisplayXDR 0x06141305,6016x3384@60,auto,2.0"

      # Apple StudioDisplay
      "desc:Apple Computer Inc StudioDisplay 0x47040065,preferred,auto,1.8"

      # Disable unknown monitors
      "Unknown Unknown Unknown,disable"

      # Auto-configure any other monitors
      ",preferred,auto,1.8"
    ];
  };
}
