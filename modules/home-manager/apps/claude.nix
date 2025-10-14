{ config
, lib
, pkgs
, ...
}:

let
  chromeScript = "${config.home.homeDirectory}/.local/bin/chrome";
in
{
  # Desktop entry for Claude
  xdg.desktopEntries.Claude = {
    name = "Claude";
    comment = "Claude AI Assistant Web App";
    exec = "${chromeScript} --new-window --ozone-platform=wayland --app=https://claude.ai --name=Claude --class=Claude";
    icon = "${../../../config/icons/claude.svg}";
    terminal = false;
    type = "Application";
    startupNotify = true;
  };
}

