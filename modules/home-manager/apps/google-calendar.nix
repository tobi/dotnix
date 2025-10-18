{ config
, lib
, pkgs
, ...
}:

let
  chromeScript = "${config.home.homeDirectory}/.local/bin/chrome";
in
{
  # Desktop entry for Google Calendar
  xdg.desktopEntries.GoogleCalendar = {
    name = "Google Calendar";
    comment = "Google Calendar";
    exec = "${chromeScript} --user-data-dir=${config.home.homeDirectory}/Shopify/profile --new-window --app=https://calendar.google.com --name=GoogleCalendar --class=GoogleCalendar";
    icon = "${../../../config/icons/google-calendar.svg}";
    terminal = false;
    type = "Application";
    startupNotify = true;
  };

  # Register hotkey for open-or-focus
  dotnix.desktop.hotkeys."Super+C" = {
    executable = "GoogleCalendar";
    focusClass = "chrome-calendar.google.com__-Default";
  };
}
