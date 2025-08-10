{ pkgs, theme, ... }:
{
  services.mako = {
    enable = true;
    settings = {
      default-timeout = 2000;
      width = 350;
      height = 150;
      icons = true;
      border-size = 1;
      border-radius = 8;
      background-color = "#${theme.palette.base00}";
      text-color = "#${theme.palette.base05}";
      border-color = "#${theme.palette.base0D}";
      progress-color = "over #${theme.palette.base02}";
      anchor = "bottom-right";
      layer = "overlay";

      font = "Inter 12";
      padding = "15";
      margin = "20";

      "urgency=low" = {
        border-color = "#${theme.palette.base03}";
      };

      "urgency=normal" = {
        border-color = "#${theme.palette.base0D}";
      };

      "urgency=high" = {
        border-color = "#FF0000";
        default-timeout = 0;
      };

      "category=mpd" = {
        default-timeout = 2000;
        group-by = "category";
      };
    };
  };
}

