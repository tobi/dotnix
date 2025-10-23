{ ... }:

{
  programs.niri.settings.window-rules = [
    # xdg-desktop-portal-gtk file picker
    {
      matches = [
        { app-id = "^xdg-desktop-portal-gtk$"; }
        { title = "^Open"; }
      ];
      open-floating = true;
      max-width = 1000;
      max-height = 1000;
    }

    # Google Chrome window
    {
      matches = [
        { app-id = "^google-chrome.*"; }
        { app-id = "^chrome-.*"; }
      ];
      # default-column-width.proportion = 0.66;
      open-focused = true;
    }

    {
      matches = [{
        app-id = "^chrome-meet.google.com__-Default$";
      }];
      open-focused = true;
      default-column-width.proportion = 0.99;
    }

    # Global corner radius for all windows
    {
      geometry-corner-radius = {
        top-left = 6.0;
        top-right = 6.0;
        bottom-left = 6.0;
        bottom-right = 6.0;
      };
      clip-to-geometry = true;
    }
  ];
}
