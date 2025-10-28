{
  config,
  lib,
  pkgs,
  ...
}:

let
  chromeScript = "${config.home.homeDirectory}/.local/bin/chrome";
in
{
  # Desktop entry for Google Meet
  xdg.desktopEntries.GoogleMeet = {
    name = "Google Meet";
    comment = "Google Meet Video Conferencing";
    exec = "${chromeScript} --user-data-dir=${config.home.homeDirectory}/Shopify/profile --new-window --app=https://meet.google.com --name=GoogleMeet %U";
    icon = "${../../../config/icons/google-meet.svg}";
    terminal = false;
    type = "Application";
    startupNotify = true;
  };

  # Register hotkey for open-or-focus
  dotnix.desktop.hotkeys."Super+Shift+E" = {
    executable = "GoogleMeet";
    focusClass = "chrome-meet.google.com__-Default";
    cmd = "google-meet";
  };
}
