{ config
, lib
, pkgs
, ...
}:

{
  programs.google-chrome.enable = true;

  home.file.".local/bin/chrome" = {
    source = ./chrome/chrome;
    executable = true;
  };

  # Set default applications for Google Chrome
  xdg.mimeApps.defaultApplications = {
    "text/html" = "google-chrome.desktop";
    "x-www-browser" = "google-chrome.desktop";
    "x-scheme-handler/http" = "google-chrome.desktop";
    "x-scheme-handler/https" = "google-chrome.desktop";
    "x-scheme-handler/pdf" = "google-chrome.desktop";
    "application/pdf" = "google-chrome.desktop";
  };

  # Desktop entry for Google Chrome
  xdg.desktopEntries.google-chrome = {
    name = "Google Chrome";
    genericName = "Web Browser";
    comment = "Access the Internet";
    exec = "chrome %U";
    terminal = false;
    icon = "google-chrome";
    type = "Application";
    categories = [
      "Network"
      "WebBrowser"
    ];
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
        exec = "chrome";
      };
      new-private-window = {
        name = "New Incognito Window";
        exec = "chrome --incognito";
      };
    };
  };

  # Desktop entry for Google Chrome (Shopify profile)
  xdg.desktopEntries.google-chrome-shopify = {
    name = "Google Chrome (Shopify)";
    genericName = "Web Browser";
    comment = "Access the Internet with Shopify profile";
    exec = "chrome --user-data-dir=\\$HOME/Shopify/profile %U";
    terminal = false;
    icon = "google-chrome";
    type = "Application";
    categories = [
      "Network"
      "WebBrowser"
    ];
  };
}

