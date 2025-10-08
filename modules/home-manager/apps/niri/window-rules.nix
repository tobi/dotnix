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
        { app-id = "^google-chrome"; }
      ];
      default-column-width.proportion = 0.66;
    }

    {
      matches = [{
        app-id = "^chrome-meet.google.com__-Default$";
      }];
      open-focused = true;
      default-column-width.proportion = 0.99;

    }

    {
      matches = [
        { app-id = "^chrome-app.slack.com__client-Default$"; }
      ];
      open-focused = true;
      default-column-width.proportion = 0.66;
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
