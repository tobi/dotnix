{ ... }:

{
  programs.niri.settings = {
    prefer-no-csd = true;

    hotkey-overlay.skip-at-startup = true;

    overview.workspace-shadow.enable = false;

    environment = { };

    layer-rules = [
      {
        matches = [
          { namespace = "^wallpaper$"; }
        ];
        place-within-backdrop = true;
      }
    ];

    screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

    # switch-events.lid-close.action.spawn = [ "systemctl" "suspend" ];
    # switch-events.lid-close.action.spawn = [ "swaylock" ];

  };
}
