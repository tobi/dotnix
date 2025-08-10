{ pkgs, ... }:

{

  home.packages = with pkgs; [
    appimage-run
  ];

  home.file.".local/bin/cursor" = {
    source = ./cursor/cursor;
    executable = true;
  };

  # Define a package for the Cursor AppImage
  xdg.desktopEntries.cursor = {
    name = "Cursor";
    comment = "Launch the latest Cursor AppImage";
    exec = "${pkgs.stdenv.shell} ${./cursor}";
    icon = "Cursor";
    terminal = false;
    type = "Application";
    categories = [
      "Utility"
    ];
  };
}


