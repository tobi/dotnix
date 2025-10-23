{ theme, lib, config, ... }:
let
  palette = theme.palette;
in
lib.mkIf (config.dotnix.desktop.launcher == "fuzzel") {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        # Window properties
        width = 50;
        horizontal-pad = 40;
        vertical-pad = 8;
        inner-pad = 8;

        # Performance
        layer = "overlay";
        exit-on-keyboard-focus-loss = true;

        # Icons
        icon-theme = "hicolor";
        icons-enabled = true;

        # Font
        font = "FiraCode Nerd Font:size=12";

        # Matching
        y = true;
        show-actions = true;
        terminal = "ghostty";

        # Appearance
        line-height = 25;
        letter-spacing = 0;

        # Prompt
        prompt = "❯ ";

        # Tabs
        tabs = 4;
      };

      colors = {
        background = "${palette.base00}e6"; # with transparency
        text = "${palette.base05}ff";
        match = "${palette.base0D}ff";
        selection = "${palette.base01}ff";
        selection-text = "${palette.base05}ff";
        selection-match = "${palette.base0D}ff";
        border = "${palette.base02}ff";
        placeholder = "${palette.base03}ff";
      };

      border = {
        width = 2;
        radius = 8;
      };

      dmenu = {
        exit-immediately-if-empty = true;
      };
    };
  };
}

