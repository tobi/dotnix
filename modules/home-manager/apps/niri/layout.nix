{ ... }:

{
  programs.niri.settings.layout = {
    gaps = 15;
    center-focused-column = "never";
    background-color = "transparent";

    preset-column-widths = [
      { proportion = 0.33333; }
      { proportion = 0.5; }
      { proportion = 0.66667; }
    ];

    default-column-width = {
      proportion = 0.5;
    };

    focus-ring = {
      enable = true;
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
      enable = false;
      width = 3;
      active.color = "#ffc87f";
      inactive.color = "#505050";
      urgent.color = "#9b0000";
    };

    shadow = {
      enable = true;
      softness = 30.0;
      spread = 3.0;
      offset = {
        x = 3;
        y = 3;
      };
      color = "#000000";
    };

    struts = {};
  };
}
