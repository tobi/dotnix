{ config, lib, pkgs, ... }:

{
  # Desktop entry for ChatGPT
  xdg.desktopEntries.ChatGPT = {
    name = "ChatGPT";
    comment = "ChatGPT Web App";
    exec = "chromium --ozone-platform=wayland --app=https://chat.openai.com --class=ChatGPT --app-id=ChatGPT --single-process";
    terminal = false;
    type = "Application";
    mimeType = [ "text/html" "text/xml" "application/xhtml_xml" ];
    startupNotify = true;
  };
}
