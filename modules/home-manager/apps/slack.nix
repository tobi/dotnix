{ config
, lib
, pkgs
, ...
}:

let
  chromeScript = "${config.home.homeDirectory}/.local/bin/chrome";
in
{
  # Desktop entry for Slack (Shopify profile)
  xdg.desktopEntries.Slack = {
    name = "Slack";
    comment = "Slack Desktop";
    exec = "${chromeScript} --user-data-dir=Shopify/profile --new-window --app=https://app.slack.com/client --name=Slack --class=Slack";
    terminal = false;
    icon = "slack";
    type = "Application";
    startupNotify = true;
    categories = [
      "Network"
      "InstantMessaging"
    ];
  };
}
