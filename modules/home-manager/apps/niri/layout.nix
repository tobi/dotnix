_:

{
  programs.niri.settings = {
    layout = {
      gaps = 8;
      background-color = "transparent";
      always-center-single-column = true;

      preset-column-widths = [
        { proportion = 0.66; }
        { proportion = 0.33; }
        { proportion = 0.50; }
      ];

      default-column-width = {
        fixed = 726; # let windows decide
        #proportion = 0.5;
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
        softness = 20.0;
        spread = 1;
        offset = {
          x = 2;
          y = 2;
        };
        color = "#222222";
      };

      struts = {
        left = 10;
        right = 10;
      };
    };
  };
}
