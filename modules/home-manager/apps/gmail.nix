{
  config,
  lib,
  pkgs,
  ...
}:

let
  chromeScript = "${config.home.homeDirectory}/.local/bin/chrome";
in
{
  # Desktop entry for Gmail
  xdg.desktopEntries.Gmail = {
    name = "Gmail";
    comment = "Google Mail";
    exec = "${chromeScript} --user-data-dir=${config.home.homeDirectory}/Shopify/profile --new-window --app=https://mail.google.com --name=Gmail %U";
    icon = "${../../../config/icons/gmail.svg}";
    terminal = false;
    type = "Application";
    startupNotify = true;
  };

  # Register hotkey for open-or-focus
  dotnix.desktop.hotkeys."Super+Shift+M" = {
    executable = "Gmail";
    focusClass = "chrome-mail.google.com__-Default";
    cmd = "gmail";
  };
}
