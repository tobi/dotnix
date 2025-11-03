{ theme, ... }:

{
  wayland.windowManager.hyprland.settings = {
    env = [
      # Cursor configuration
      "XCURSOR_SIZE,24"
      "HYPRCURSOR_SIZE,24"

      # GTK theme based on color scheme variant
      "GTK_THEME,${if theme.variant == "light" then "Adwaita" else "Adwaita:dark"}"
    ];

    # Better HiDPI support for X11 apps
    xwayland.force_zero_scaling = true;
  };
}
