{ ... }:

{
  programs.niri.settings.input = {
    keyboard = {
      xkb.options = "caps:super";
      repeat-delay = 400;
      repeat-rate = 40;
      track-layout = "window";
    };

    touchpad = {
      tap = true;
      dwt = true;
      accel-profile = "flat";
      click-method = "clickfinger";
      scroll-factor = 0.5;
    };

    mouse = {
      accel-profile = "flat";
    };

    warp-mouse-to-focus = true;

    focus-follows-mouse = {
      enable = true;
      max-scroll-amount = "0%";
    };
  };
}
