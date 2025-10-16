{ ... }:

{
  programs.niri.settings = {
    layout = {
      gaps = 10;
      background-color = "transparent";
      always-center-single-column = true;

      preset-column-widths = [
        { proportion = 0.333; }
        { proportion = 0.5; }
        { proportion = 0.666; }
      ];

      default-column-width = {
        proportion = 0.5;
      };

      focus-ring = {
        enable = false;
        width = 1;
        active.gradient = {
          from = "teal";
          to = "purple";
          angle = 90;
        };
        inactive.gradient = {
          from = "#505050";
          to = "#808080";
          angle = 45;
          relative-to = "workspace-view";
        };
      };

      border = {
        enable = true;
        width = 1;
        active.color = "#cccccc";
        inactive.color = "#505050";
        urgent.color = "#9b0000";
      };

      shadow = {
        enable = true;
        softness = 10.0;
        spread = 1;
        offset = {
          x = 1.5;
          y = 1.5;
        };
        color = "#000000";
      };

      struts = {
        left = 10;
        right = 10;
      };
    };
  };
}
