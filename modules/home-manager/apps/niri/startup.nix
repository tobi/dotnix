{ ... }:

{
  programs.niri.settings.spawn-at-startup = [
    { argv = [ "swaylock" ]; }
    { argv = [ "waybar" ]; }
    { argv = [ "wbg" ".config/wallpaper.jpg" ]; }
    { argv = [ "ghostty" ]; }
    { argv = [ "sway-audio-idle-inhibit" ]; }
  ];
}
