{ config, ... }:

let
  chromeScript = "${config.home.homeDirectory}/.local/bin/chrome";
in
{
  # Desktop entry for Logseq
  xdg.desktopEntries.Logseq = {
    name = "Logseq";
    comment = "Logseq Knowledge Management Web App";
    exec = "${chromeScript} --new-window --ozone-platform=wayland --app=https://test.logseq.com --name=Logseq %U";
    icon = "${../../../config/icons/logseq.svg}";
    terminal = false;
    type = "Application";
    startupNotify = true;
  };
}
