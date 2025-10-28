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
  # Desktop entry for Slack (Shopify profile)
  xdg.desktopEntries.Slack = {
    name = "Slack";
    comment = "Slack Desktop";
    exec = "${chromeScript} --user-data-dir=${config.home.homeDirectory}/Shopify/profile --new-window --app=https://app.slack.com/client --name=Slack %U";
    terminal = false;
    icon = "slack";
    type = "Application";
    startupNotify = true;
    categories = [
      "Network"
      "InstantMessaging"
    ];
  };

  # Register hotkey for open-or-focus
  dotnix.desktop.hotkeys."Super+Shift+S" = {
    executable = "Slack";
    focusClass = "chrome-app.slack.com__client-Default";
  };
}
