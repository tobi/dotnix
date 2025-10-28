{
  config,
  pkgs,
  ...
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

  # XDG configuration
  xdg = {
    # Set default applications for Google Chrome
    mimeApps.defaultApplications = {
      "text/html" = "google-chrome-shopify.desktop";
      "x-www-browser" = "google-chrome-shopify.desktop";
      "x-scheme-handler/http" = "google-chrome-shopify.desktop";
      "x-scheme-handler/https" = "google-chrome-shopify.desktop";
      "x-scheme-handler/pdf" = "google-chrome-shopify.desktop";
      "application/pdf" = "google-chrome-shopify.desktop";
    };

    # Desktop entries
    desktopEntries = {
      google-chrome = {
        name = "Google Chrome";
        genericName = "Web Browser";
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
      };

      google-chrome-shopify = {
        name = "Google Chrome (Shopify)";
        genericName = "Web Browser";
        exec = "${chromeScript} --new-window --user-data-dir=${config.home.homeDirectory}/Shopify/profile --class=google-chrome-shopify %U";
        terminal = false;
        icon = "google-chrome";
        type = "Application";
        categories = [
          "Network"
          "WebBrowser"
        ];
      };
    };
  };

  # Register hotkeys for open-or-focus
  dotnix.desktop.hotkeys."Super+Shift+B" = {
    executable = "google-chrome";
    focusClass = "google-chrome";
  };

  dotnix.desktop.hotkeys."Super+Shift+N" = {
    executable = "google-chrome-shopify";
    focusClass = "google-chrome-shopify";
    cmd = "google-chrome-shopify";
  };
}
