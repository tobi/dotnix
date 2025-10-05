{ config
, lib
, pkgs
, ...
}:

{
  # Desktop entry for Slack (Shopify profile)
  xdg.desktopEntries.Slack = {
    name = "Slack";
    comment = "Slack Desktop";
    exec = "chrome --user-data-dir=\\$HOME/Shopify/profile --new-window --app=https://app.slack.com --name=Slack --class=Slack";
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
