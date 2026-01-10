{ config, ... }:
let
  theme = config.dotnix.theme;
in
{
  wayland.windowManager.hyprland.settings = {
    env = [
      # Cursor configuration - scaled for HiDPI
      "XCURSOR_SIZE,32"
      "HYPRCURSOR_SIZE,32"

      # GTK scaling - use integer scale for compatibility
      # GDK_SCALE must be integer (1, 2, 3), so use 2 for HiDPI
      "GDK_SCALE,2"
      # GDK_DPI_SCALE adjusts fonts/text to compensate
      # 2 * 0.8 = 1.6 effective scale (matches laptop display)
      "GDK_DPI_SCALE,0.8"

      # Qt scaling
      "QT_AUTO_SCREEN_SCALE_FACTOR,1"
      "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"

      # GTK theme based on color scheme variant
      "GTK_THEME,${if theme.variant == "light" then "Adwaita" else "Adwaita:dark"}"
    ];

    # Better HiDPI support for X11 apps
    xwayland.force_zero_scaling = true;
  };
}
