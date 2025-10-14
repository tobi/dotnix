{ config
, lib
, pkgs
, ...
}:

let
  chromeScript = "${config.home.homeDirectory}/.local/bin/chrome";
in
{
  # Desktop entry for NeuroTracker
  xdg.desktopEntries.NeuroTracker = {
    name = "NeuroTracker";
    comment = "NeuroTracker Cognitive Training";
    exec = "${chromeScript} --new-window --app=https://web.neurotrackerx.com --name=NeuroTracker --class=NeuroTracker";
    icon = "${../../../config/icons/neurotracker.svg}";
    terminal = false;
    type = "Application";
    startupNotify = true;
  };

  # Register hotkey for open-or-focus
  dotnix.desktop.hotkeys."Super+T" = {
    executable = "NeuroTracker";
    focusClass = "chrome-web.neurotrackerx.com__-Default";
  };
}
