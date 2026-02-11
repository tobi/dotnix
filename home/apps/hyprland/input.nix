_: {
  wayland.windowManager.hyprland.settings = {
    input = {
      kb_layout = "us";
      kb_options = "caps:super";

      repeat_delay = 400;
      repeat_rate = 40;
      numlock_by_default = true;

      follow_mouse = 2;
      mouse_refocus = true;
      float_switch_override_focus = 0;

      sensitivity = 0.0;
      accel_profile = "flat";

      touchpad = {
        natural_scroll = false;
        tap-to-click = true;
        clickfinger_behavior = true;
        scroll_factor = 0.5;
      };
    };

    cursor = {
      no_hardware_cursors = false;
      hide_on_key_press = true;
      default_monitor = "";
    };
  };
}
