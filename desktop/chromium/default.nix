{ config, lib, pkgs, ... }:

{
  # Set default applications for Chromium
  xdg.mimeApps.defaultApplications = {
    "text/html" = "Chromium.desktop";
  };

  # Desktop entry for Chromium
  xdg.desktopEntries.Chromium = {
    name = "Chromium";
    genericName = "Web Browser";
    comment = "Access the Internet";
    exec = "chromium --enable-features=UseOzonePlatform --ozone-platform=wayland %U";
    terminal = false;
    icon = "google-chrome";
    type = "Application";
    categories = [ "Network" "WebBrowser" ];
    mimeType = [
      "text/html"
      "text/xml"
      "application/xhtml_xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
    ];
    actions = {
      new-window = {
        name = "New Window";
        exec = "chromium --enable-features=UseOzonePlatform --ozone-platform=wayland";
      };
      new-private-window = {
        name = "New Incognito Window";
        exec = "chromium --incognito --enable-features=UseOzonePlatform --ozone-platform=wayland";
      };
    };
  };
}
