{ config
, lib
, pkgs
, ...
}:

{
  # Desktop entry for Google Meet
  xdg.desktopEntries.GoogleMeet = {
    name = "Google Meet";
    comment = "Google Meet Video Conferencing";
    exec = "chrome --user-data-dir=\\$HOME/Shopify/profile --new-window --app=https://meet.google.com --name=GoogleMeet --class=GoogleMeet";
    terminal = false;
    type = "Application";
    startupNotify = true;
  };
}
