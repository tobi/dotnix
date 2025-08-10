{ config
, lib
, pkgs
, theme
, ...
}:
let
  opacity = rgb: "${rgb}AA";
in
{

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
      font-size = 60;
      indicator-radius = 100;
      indicator-thickness = 7;
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
      datestr = " %a, %B %-d";
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

  # Use Home Manager's built-in swayidle service instead of manual systemd service
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 120; # 2 minutes - turn off screens
        command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
      }
      {
        timeout = 300; # 5 minutes - lock screen and then suspend
        command = "${pkgs.swaylock-effects}/bin/swaylock && systemctl suspend";
      }
    ];
    # Resume commands - turn monitors back on when activity is detected
    events = [
      {
        event = "after-resume";
        command = "${pkgs.niri}/bin/niri msg action power-on-monitors";
      }
    ];
  };
}

