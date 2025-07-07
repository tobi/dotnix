{ config
, lib
, pkgs
, ...
}:

{
  # Desktop entry for ChatGPT
  xdg.desktopEntries.ChatGPT = {
    name = "ChatGPT";
    comment = "ChatGPT Web App";
    exec = "${pkgs.google-chrome}/bin/google-chrome-stable --new-window --ozone-platform=wayland --app=https://chat.openai.com --name=ChatGPT --class=ChatGPT";
    terminal = false;
    type = "Application";
    # mimeType = [ "text/html" "text/xml" "application/xhtml_xml" ];
    startupNotify = true;
  };
}
