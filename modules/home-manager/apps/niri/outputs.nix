{ ... }:

{
  programs.niri.settings.outputs = {
    "eDP-1" = {
      scale = 1.5;
      transform = "normal";
      position = {
        x = 0;
        y = 0;
      };
    };

    "Apple Computer Inc StudioDisplay 0x47040065" = {
      scale = 1.8;
      focus-at-startup = true;
    };
  };
}
