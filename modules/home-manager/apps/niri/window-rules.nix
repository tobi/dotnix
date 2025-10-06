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
        { title = "^google-chrome$"; }
      ];
    }

    # Firefox Picture-in-Picture
    {
      matches = [
        { app-id = "firefox$"; title = "^Picture-in-Picture$"; }
      ];
      open-floating = true;
    }

    # Global corner radius for all windows
    {
      geometry-corner-radius = 14.0;
      clip-to-geometry = true;
    }
  ];
}
