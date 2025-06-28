{ config, lib, pkgs, ... }:
let
  isLinux = pkgs.stdenv.isLinux;
in
{

  home.packages = with pkgs; [
    wbg
    mako
    rustdesk
    gcr
    gnome-keyring
    libsecret
  ];

  programs.vscode.enable = true;
  programs.firefox.enable = true;
  programs.fuzzel.enable = true;
  programs.yazi.enable = true;
  programs.swaylock.enable = true;


  programs.waybar = {
    enable = true;
    style = builtins.readFile ./config/waybar.css;
    settings = {
      mainBar = {
        layer = "top";
        # position = "top";
        height = 30;
        modules-center = [ "clock" ];
        modules-left = [ "bluetooth" "network" ]; # see below
        modules-right = [ "cpu" "memory" "tray" ];

        /* Add any additional settings for the main bar here */
      };

    };
  };

  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    CHROMIUM_FLAGS = "--enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime --wayland-text-input-version=3";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };

  services.gnome-keyring.enable = true;

  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };

  # Wayland wallpaper daemon
  services.swww.enable = true;

  # XDG configuration for proper application launching
  xdg = lib.mkIf isLinux {
    enable = true;

    # Set default applications
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "Chromium.desktop";
        #     "x-scheme-handler/http" = "chromium-browser.desktop";
        #     "x-scheme-handler/https" = "chromium-browser.desktop";
        #     "x-scheme-handler/about" = "chromium-browser.desktop";
        #     "x-scheme-handler/unknown" = "chromium-browser.desktop";
      };
    };


    desktopEntries = {
      "ChatGPT" = {
        name = "ChatGPT";
        comment = "ChatGPT Web App";
        exec = "chromium --ozone-platform=wayland --app=https://chat.openai.com --class=ChatGPT --app-id=ChatGPT";
        terminal = false;
        type = "Application";
        # icon = "chatgpt"; # Use a suitable icon name or provide a path
        mimeType = [ "text/html" "text/xml" "application/xhtml_xml" ];
        startupNotify = true;
        actions = {
          NewWindow = {
            name = "New Window";
            exec = "chromium --ozone-platform=wayland --app=https://chat.openai.com --class=ChatGPT --app-id=ChatGPT --new-window";
          };
        };
      };

      "Chromium" = {
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

      "Ghostty" = {
        name = "Ghostty";
        comment = "Wayland-native terminal emulator";
        exec = "ghostty";
        terminal = false;
        type = "Application";
        icon = "terminal"; # Use a suitable icon name or provide a path
        categories = [ "Utility" "TerminalEmulator" ];
      };
    };

  };
}
