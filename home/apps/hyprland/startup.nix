_: {
  wayland.windowManager.hyprland.settings = {
    # Run once at Hyprland startup
    exec-once = [
      "systemctl --user start hyprpolkitagent"
      "walker --gapplication-service"
      "waybar"
    ];

    # Run on config reload (including after nixos-rebuild switch)
    exec = [
      # Preserve lid state after rebuild - disable laptop display if lid is closed
      "sh -c 'grep -q closed /proc/acpi/button/lid/*/state && hyprctl keyword monitor eDP-1,disable || true'"
    ];
  };
}
