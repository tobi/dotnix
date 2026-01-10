{ config, ... }:
let
  inherit (config.dotnix) theme;
  # Convert palette to RGB format for hyprlock
  toRgb = hex: "rgb(${hex})";
in
{
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
        grace = 0;
        no_fade_in = false;
      };

      auth = {
        fingerprint = {
          enabled = true;
        };
      };

      background = {
        monitor = "";
        path = theme.wallpaperPath;
        blur_passes = 2;
        blur_size = 7;
        contrast = 0.8916;
        brightness = 0.8172;
        vibrancy = 0.1696;
        vibrancy_darkness = 0.0;
      };

      label = [
        # Time
        {
          monitor = "";
          text = "$TIME";
          color = toRgb theme.palette.base05;
          font_size = 90;
          font_family = theme.systemFont;
          position = "0, 80";
          halign = "center";
          valign = "center";
        }

        # Date
        {
          monitor = "";
          text = "cmd[update:1000] date +\"%A, %B %d\"";
          color = toRgb theme.palette.base04;
          font_size = 24;
          font_family = theme.systemFont;
          position = "0, -10";
          halign = "center";
          valign = "center";
        }
      ];

      input-field = {
        monitor = "";
        size = "300, 60";
        outline_thickness = 2;
        dots_size = 0.2;
        dots_spacing = 0.2;
        dots_center = true;
        outer_color = toRgb theme.palette.base0D;
        inner_color = toRgb theme.palette.base00;
        font_color = toRgb theme.palette.base05;
        check_color = toRgb theme.palette.base0B;
        fail_color = toRgb theme.palette.base08;
        fade_on_empty = false;
        placeholder_text = "<span foreground=\"##${theme.palette.base04}\">Password...</span>";
        hide_input = false;
        position = "0, -120";
        halign = "center";
        valign = "center";
      };
    };
  };
}
