{ theme, ... }:

let
  # Helper to convert hex color to rgba with alpha
  hexToRgba = hex: alpha: "rgba(${hex}${alpha})";

  # Theme-based colors
  activeBorder = hexToRgba theme.palette.base0D "aa";
  inactiveBorder = hexToRgba theme.palette.base03 "aa";
in
{
  wayland.windowManager.hyprland.settings = {
    general = {
      gaps_in = 4;
      gaps_out = 5;
      border_size = 1;
      "col.active_border" = activeBorder;
      "col.inactive_border" = inactiveBorder;
      layout = "dwindle";
      resize_on_border = true;
    };

    decoration = {
      rounding = 4;

      blur = {
        enabled = true;
        size = 5;
        passes = 2;
        new_optimizations = true;
        xray = false;
        ignore_opacity = false;
      };

      shadow = {
        enabled = true;
        range = 8;
        render_power = 2;
        color = hexToRgba theme.palette.base00 "99";
      };

      dim_inactive = false;
      dim_strength = 0.05;
    };

    animations = {
      enabled = true;

      bezier = [
        "easeOutQuint,0.23,1,0.32,1"
        "easeInOutCubic,0.65,0,0.35,1"
        "quick,0.15,0,0.1,1"
      ];

      animation = [
        "windows,1,4,easeOutQuint,slide"
        "windowsOut,1,4,easeInOutCubic,slide"
        "border,1,10,default"
        "fade,1,3,quick"
        "workspaces,1,5,easeOutQuint,slidevert"
      ];
    };

    dwindle = {
      pseudotile = true;
      preserve_split = true;
      # Note: dwindle doesn't support centering single windows with max width
      # Consider using master layout if you want that behavior
      split_width_multiplier = 1.0;
    };

    master = {
      new_status = "master";
      new_on_top = false;
      mfact = 0.55;
      # Center single windows - orientation = "center" centers the master window
      orientation = "center";
    };

    misc = {
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
      force_default_wallpaper = 0;
      vfr = true;
      vrr = 1;
      mouse_move_enables_dpms = true;
      key_press_enables_dpms = true;
    };
  };
}
