{
  pkgs,
  config,
  lib,
  ...
}:
let
  theme = config.dotnix.theme;
  opacity = rgb: "${rgb}AA";
in
{
  config = lib.mkIf (config.dotnix.wm == "niri") {

  home.packages = with pkgs; [
    swaylock-effects
    sway-audio-idle-inhibit
  ];

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      scaling = "fill";
      screenshots = true;
      color = opacity theme.background;
      font = "FiraCode Nerd Font";
      line-color = opacity theme.cyan;
      font-size = 36;
      indicator-radius = 100;
      indicator-thickness = 10;
      show-failed-attempts = true;
      ignore-empty-password = true;
      indicator-caps-lock = true;
      indicator-idle-visible = true;
      grace = 0;
      fade-in = 0.3;
      effect-blur = "7x5";
      effect-vignette = "0.5:0.5";

      # Clock and text display
      clock = true;
      indicator = true;
      datestr = " %a, %b %-d";
      timestr = " %I:%M%p";
      text-ver = "󰭖";
      text-wrong = "󱋟";
      text-clear = "󰯢";
      text-caps-lock = "Caps Lock";

      # Colors using theme named variables
      inside-color = "${theme.backgroundAlt}66";
      inside-clear-color = "${theme.backgroundAlt}66";
      inside-caps-lock-color = "${theme.backgroundAlt}66";
      inside-ver-color = "${theme.backgroundAlt}66";
      inside-wrong-color = "${theme.red}66";
      key-hl-color = "${theme.cyan}AA";
      layout-bg-color = "${theme.backgroundAlt}66";
      layout-border-color = "${theme.cyan}66";
      layout-text-color = theme.foreground;
      line-clear-color = theme.blue;
      line-ver-color = theme.blue;
      line-wrong-color = theme.red;
      ring-color = opacity theme.background;
      separator-color = theme.blue;
      ring-clear-color = theme.blue;
      ring-caps-lock-color = theme.magenta;
      ring-ver-color = theme.green;
      ring-wrong-color = theme.red;
      text-color = theme.foreground;
      text-clear-color = theme.foreground;
      text-caps-lock-color = theme.foreground;
      text-ver-color = theme.green;
      text-wrong-color = theme.red;
    };
  };

  # Use Home Manager's built-in swayidle service
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 180; # 3 minutes - lock screen
        command = "${pkgs.swaylock-effects}/bin/swaylock -f";
      }
      {
        timeout = 280; # 4 minutes 40 seconds - turn off monitors
        command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
        resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
      }
      {
        timeout = 355; # in seconds
        command = "${pkgs.libnotify}/bin/notify-send 'Locking in 5 seconds' -t 5000";
      }
      {
        timeout = 360; # 6 minutes - suspend-then-hibernate
        command = "systemctl suspend-then-hibernate";
      }
    ];
    events = [
      # Lock before any sleep/suspend (lid close, suspend button, etc)
      {
        event = "before-sleep";
        command = "${pkgs.swaylock-effects}/bin/swaylock -f --fade-in 0.3";
      }
      # Turn monitors back on after resume
      {
        event = "after-resume";
        command = "${pkgs.niri}/bin/niri msg action power-on-monitors";
      }
      # Lock when logind signals lock
      {
        event = "lock";
        command = "${pkgs.swaylock-effects}/bin/swaylock -f --fade-in 0.3";
      }
    ];
    # extraArgs = [ "-w" ]; # Wait for lock command to finish before continuing
  };
  };
}
