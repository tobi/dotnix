{ config
, lib
, pkgs
, ...
}:

let
  chromeScript = "${config.home.homeDirectory}/.local/bin/chrome";
in
{
  programs.google-chrome.enable = true;

  home.file.".local/bin/chrome" = {
    text = ''
      #!/usr/bin/env bash
      exec ${pkgs.google-chrome}/bin/google-chrome-stable \
        --enable-features=UseOzonePlatform,WebAuthenticationRemoteDesktopSupport,WebAuthenticationCable,DesktopPWAsLinkCapturing,DesktopPWAsWithoutExtensions,WebRTCPipeWireCapturer \
        --disable-features=WebAuthenticationChromeOSAuthenticator \
        --ozone-platform=wayland \
        --enable-wayland-ime \
        --wayland-text-input-version=3 \
        --enable-logging=stderr \
        --enable-bluetooth-serial-communication \
        --enable-experimental-web-platform-features \
        --password-store=gnome-libsecret \
        "$@"
    '';
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
    exec = "${chromeScript} --class=google-chrome %U";
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
        exec = "${chromeScript} --class=google-chrome --new-window";
      };
      new-private-window = {
        name = "New Incognito Window";
        exec = "${chromeScript} --class=google-chrome --incognito";
      };
    };
  };

  # Desktop entry for Google Chrome (Shopify profile)
  xdg.desktopEntries.google-chrome-shopify = {
    name = "Google Chrome (Shopify)";
    genericName = "Web Browser";
    comment = "Access the Internet with Shopify profile";
    exec = "${chromeScript} --user-data-dir=Shopify/profile --class=google-chrome-shopify %U";
    terminal = false;
    icon = "google-chrome";
    type = "Application";
    categories = [
      "Network"
      "WebBrowser"
    ];
  };
}

