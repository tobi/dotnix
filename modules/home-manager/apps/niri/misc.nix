{ ... }:

{
  programs.niri.settings = {
    prefer-no-csd = true;

    hotkey-overlay = {
      skip-at-startup = true;
    };

    screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

    overview = {
      workspace-shadow.enable = false;
    };

    environment = {};

    layer-rules = [
      {
        matches = [
          { namespace = "^wallpaper$"; }
        ];
        place-within-backdrop = true;
      }
    ];

    switch-events.lid-close.action.spawn = [ "systemctl" "suspend" ];
  };
}
