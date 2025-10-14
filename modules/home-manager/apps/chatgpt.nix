{ config
, lib
, pkgs
, ...
}:

let
  chromeScript = "${config.home.homeDirectory}/.local/bin/chrome";
in
{
  # Desktop entry for ChatGPT
  xdg.desktopEntries.ChatGPT = {
    name = "ChatGPT";
    comment = "ChatGPT Web App";
    exec = "${chromeScript} --new-window --app=https://chat.openai.com --name=ChatGPT --class=ChatGPT";
    icon = "${../../../config/icons/chatgpt.svg}";
    terminal = false;
    type = "Application";
    # mimeType = [ "text/html" "text/xml" "application/xhtml_xml" ];
    startupNotify = true;
  };

  # Register hotkey for open-or-focus
  dotnix.desktop.hotkeys."Super+A" = {
    executable = "ChatGPT";
    focusClass = "chrome-chat.openai.com__-Default";
  };
}

