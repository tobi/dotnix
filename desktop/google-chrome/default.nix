{ config, lib, pkgs, ... }:

{
  # Enable Google Chrome with Wayland support
  # google-chrome-stable --enable-features=UseOzonePlatform,WebAuthenticationRemoteDesktopSupport,WebAuthenticationCable --disable-features=WebAuthenticationChromeOSAuthenticator --ozone-platform=wayland --enable-wayland-ime --wayland-text-input-version=3 --enable-bluetooth-serial-communication --enable-experimental-web-platform-features
  programs.google-chrome = {
    enable = true;
    commandLineArgs = [
      "--enable-features=UseOzonePlatform"
      "--ozone-platform=wayland"
      "--enable-wayland-ime"
      "--wayland-text-input-version=3"
      # WebAuthn and CTAP transport fixes
      "--enable-logging=stderr"
      "--v=1"
      "--enable-features=WebAuthenticationRemoteDesktopSupport,WebAuthenticationCable"
      "--disable-features=WebAuthenticationChromeOSAuthenticator"
      # Bluetooth transport debugging and fixes
      "--enable-bluetooth-serial-communication"
      "--enable-experimental-web-platform-features"
    ];
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
    exec = "${pkgs.google-chrome}/bin/google-chrome-stable --enable-features=UseOzonePlatform,WebAuthenticationRemoteDesktopSupport,WebAuthenticationCable --disable-features=WebAuthenticationChromeOSAuthenticator --ozone-platform=wayland --enable-wayland-ime --wayland-text-input-version=3 --enable-bluetooth-serial-communication --enable-experimental-web-platform-features %U";
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
        exec = "${pkgs.google-chrome}/bin/google-chrome-stable --enable-features=UseOzonePlatform,WebAuthenticationRemoteDesktopSupport,WebAuthenticationCable --disable-features=WebAuthenticationChromeOSAuthenticator --ozone-platform=wayland --enable-wayland-ime --wayland-text-input-version=3 --enable-bluetooth-serial-communication --enable-experimental-web-platform-features";
      };
      new-private-window = {
        name = "New Incognito Window";
        exec = "${pkgs.google-chrome}/bin/google-chrome-stable --incognito --enable-features=UseOzonePlatform,WebAuthenticationRemoteDesktopSupport,WebAuthenticationCable --disable-features=WebAuthenticationChromeOSAuthenticator --ozone-platform=wayland --enable-wayland-ime --wayland-text-input-version=3 --enable-bluetooth-serial-communication --enable-experimental-web-platform-features";
      };
    };
  };
}
