_:

{
  programs.niri.settings.outputs = {
    "eDP-1" = {
      scale = 1.5;
      position = {
        x = 0;
        y = 0;
      };
    };

    "Apple Computer Inc ProDisplayXDR 0x06141305" = {
      scale = 2.0;
      mode = {
        width = 6016;
        height = 3384;
        refresh = 60.0;
      };
      focus-at-startup = true;
    };

    "Apple Computer Inc StudioDisplay 0x47040065" = {
      scale = 1.8;
      focus-at-startup = true;
    };

    "Unknown Unknown Unknown" = {
      enable = false;
    };
  };
}
