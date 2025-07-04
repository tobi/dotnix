{ config
, lib
, pkgs
, ...
}:
let
  palette = config.colorScheme.palette;
in
{
  programs.alacritty = {
    enable = true;

    settings = {
      # Window settings
      window = {
        opacity = 1;
        padding = {
          x = 10;
          y = 10;
        };
        decorations = "none";
        dynamic_padding = true;
        startup_mode = "Windowed";
      };

      # Font configuration
      font = {
        normal = {
          family = "FiraCode Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "FiraCode Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "FiraCode Nerd Font";
          style = "Italic";
        };
        bold_italic = {
          family = "FiraCode Nerd Font";
          style = "Bold Italic";
        };
        size = 11;
      };

      # Colors - Base16 themed
      colors = {
        primary = {
          background = "#${palette.base00}";
          foreground = "#${palette.base05}";
        };

        cursor = {
          text = "#${palette.base00}";
          cursor = "#${palette.base05}";
        };

        vi_mode_cursor = {
          text = "#${palette.base00}";
          cursor = "#${palette.base05}";
        };

        search = {
          matches = {
            foreground = "#${palette.base00}";
            background = "#${palette.base0A}";
          };
          focused_match = {
            foreground = "#${palette.base00}";
            background = "#${palette.base09}";
          };
        };

        footer_bar = {
          foreground = "#${palette.base05}";
          background = "#${palette.base00}";
        };

        hints = {
          start = {
            foreground = "#${palette.base00}";
            background = "#${palette.base0A}";
          };
          end = {
            foreground = "#${palette.base00}";
            background = "#${palette.base09}";
          };
        };

        selection = {
          text = "#${palette.base00}";
          background = "#${palette.base02}";
        };

        normal = {
          black = "#${palette.base00}";
          red = "#${palette.base08}";
          green = "#${palette.base0B}";
          yellow = "#${palette.base0A}";
          blue = "#${palette.base0D}";
          magenta = "#${palette.base0E}";
          cyan = "#${palette.base0C}";
          white = "#${palette.base05}";
        };

        bright = {
          black = "#${palette.base03}";
          red = "#${palette.base08}";
          green = "#${palette.base0B}";
          yellow = "#${palette.base0A}";
          blue = "#${palette.base0D}";
          magenta = "#${palette.base0E}";
          cyan = "#${palette.base0C}";
          white = "#${palette.base07}";
        };

        dim = {
          black = "#${palette.base01}";
          red = "#${palette.base08}";
          green = "#${palette.base0B}";
          yellow = "#${palette.base0A}";
          blue = "#${palette.base0D}";
          magenta = "#${palette.base0E}";
          cyan = "#${palette.base0C}";
          white = "#${palette.base06}";
        };

        indexed_colors = [
          { index = 16; color = "#${palette.base09}"; }
          { index = 17; color = "#${palette.base0F}"; }
          { index = 18; color = "#${palette.base01}"; }
          { index = 19; color = "#${palette.base02}"; }
          { index = 20; color = "#${palette.base04}"; }
          { index = 21; color = "#${palette.base06}"; }
        ];
      };

      # Scrolling
      scrolling = {
        history = 10000;
        multiplier = 3;
      };

      # Mouse
      mouse = {
        hide_when_typing = true;
        bindings = [
          {
            mouse = "Middle";
            action = "PasteSelection";
          }
        ];
      };

      # Keyboard bindings
      keyboard.bindings = [
        # Copy/Paste
        {
          key = "C";
          mods = "Control|Shift";
          action = "Copy";
        }
        {
          key = "V";
          mods = "Control|Shift";
          action = "Paste";
        }

        # Font size adjustment
        {
          key = "Plus";
          mods = "Control";
          action = "IncreaseFontSize";
        }
        {
          key = "Minus";
          mods = "Control";
          action = "DecreaseFontSize";
        }
        {
          key = "Key0";
          mods = "Control";
          action = "ResetFontSize";
        }

        # New window/tab (if supported)
        {
          key = "Return";
          mods = "Control|Shift";
          action = "SpawnNewInstance";
        }
      ];

      # Terminal settings
      terminal = {
        shell = {
          program = "${pkgs.zsh}/bin/zsh";
          args = [ "--login" ];
        };
      };

      # Environment variables
      env = {
        TERM = "alacritty";
      };

      # Cursor
      cursor = {
        style = {
          shape = "Block";
          blinking = "Off";
        };
        unfocused_hollow = true;
      };

      # General settings
      general = {
        live_config_reload = true;
      };
    };
  };

  # Desktop entry for Alacritty
  xdg.desktopEntries.Alacritty = {
    name = "Alacritty";
    comment = "GPU-accelerated terminal emulator";
    exec = "alacritty";
    terminal = false;
    type = "Application";
    icon = "terminal";
    categories = [
      "Utility"
      "TerminalEmulator"
    ];
  };
}
