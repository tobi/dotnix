_:

{
  wayland.windowManager.hyprland.settings = {
    # Run once at Hyprland startup
    exec-once = [
      "systemctl --user start hyprpolkitagent"
      "walker --gapplication-service"
    ];

    # Run on config reload
    exec = [
      "pkill -SIGUSR2 waybar || waybar"
    ];
  };
}
