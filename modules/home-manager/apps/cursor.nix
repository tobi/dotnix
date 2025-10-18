{ pkgs, ... }:

{

  home.packages = with pkgs; [
    appimage-run
  ];

  # Define a package for the Cursor AppImage
  xdg.desktopEntries.cursor = {
    name = "Cursor";
    comment = "Launch the latest Cursor AppImage";
    exec = "cursor";
    icon = "${../../../config/icons/cursor.svg}";
    terminal = false;
    type = "Application";
    categories = [
      "Utility"
    ];
  };

  # Register hotkey for open-or-focus
  dotnix.desktop.hotkeys."Super+X" = {
    executable = "Cursor";
    focusClass = "cursor";
    cmd = "cursor";
  };
}


