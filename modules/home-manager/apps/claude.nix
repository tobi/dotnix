{ config
, lib
, pkgs
, ...
}:

{
  # Desktop entry for Claude
  xdg.desktopEntries.Claude = {
    name = "Claude";
    comment = "Claude AI Assistant Web App";
    exec = "${pkgs.google-chrome}/bin/google-chrome-stable --new-window --ozone-platform=wayland --app=https://claude.ai --name=Claude --class=Claude";
    terminal = false;
    type = "Application";
    startupNotify = true;
  };
}

