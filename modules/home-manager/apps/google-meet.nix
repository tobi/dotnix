{ config
, lib
, pkgs
, ...
}:

let
  chromeScript = "${config.home.homeDirectory}/.local/bin/chrome";
in
{
  # Desktop entry for Google Meet
  xdg.desktopEntries.GoogleMeet = {
    name = "Google Meet";
    comment = "Google Meet Video Conferencing";
    exec = "${chromeScript} --user-data-dir=Shopify/profile --new-window --app=https://meet.google.com --name=GoogleMeet --class=GoogleMeet";
    terminal = false;
    type = "Application";
    startupNotify = true;
  };
}
