_:

{
  programs.niri.settings.input = {
    keyboard = {
      xkb.options = "caps:super";
      repeat-delay = 400;
      repeat-rate = 40;
      numlock = true;
    };

    touchpad = {
      tap = true;
      dwt = true;
      natural-scroll = false;
      accel-profile = "flat";
      click-method = "clickfinger";
      scroll-factor = 0.5;
    };

    mouse = {
      accel-profile = "flat";
      accel-speed = 0.0;
    };

    warp-mouse-to-focus.enable = true;

    focus-follows-mouse = {
      enable = true;
      max-scroll-amount = "0%";
    };
  };

  programs.niri.settings.cursor = {
    theme = "capitaine-cursors";
    size = 28;
    hide-when-typing = true;
  };

}
