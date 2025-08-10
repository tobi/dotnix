{ config
, lib
, pkgs
, ...
}:

{
  # Desktop entry for Logseq
  xdg.desktopEntries.Logseq = {
    name = "Logseq";
    comment = "Logseq Knowledge Management Web App";
    exec = "${pkgs.google-chrome}/bin/google-chrome-stable --new-window --ozone-platform=wayland --app=https://test.logseq.com --name=Logseq --class=Logseq";
    terminal = false;
    type = "Application";
    startupNotify = true;
  };
}

