{ config
, lib
, pkgs
, theme
, ...
}:
let
  palette = theme.palette;
in
{
  programs.alacritty = {
    enable = true;

    settings = {
      # Window settings
      window = {
        opacity = 1.0;
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
          background = "#${theme.background}";
          foreground = "#${theme.foreground}";
        };

        cursor = {
          text = "#${theme.background}";
          cursor = "#${theme.foreground}";
        };

        vi_mode_cursor = {
          text = "#${theme.background}";
          cursor = "#${theme.foreground}";
        };

        search = {
          matches = {
            foreground = "#${theme.background}";
            background = "#${theme.yellow}";
          };
          focused_match = {
            foreground = "#${theme.background}";
            background = "#${theme.orange}";
          };
        };

        footer_bar = {
          foreground = "#${theme.foreground}";
          background = "#${theme.background}";
        };

        hints = {
          start = {
            foreground = "#${theme.background}";
            background = "#${theme.yellow}";
          };
          end = {
            foreground = "#${theme.background}";
            background = "#${theme.orange}";
          };
        };

        selection = {
          text = "#${theme.background}";
          background = "#${theme.selectionBg}";
        };

        normal = {
          black = "#${theme.ansi.black}";
          red = "#${theme.ansi.red}";
          green = "#${theme.ansi.green}";
          yellow = "#${theme.ansi.yellow}";
          blue = "#${theme.ansi.blue}";
          magenta = "#${theme.ansi.magenta}";
          cyan = "#${theme.ansi.cyan}";
          white = "#${theme.ansi.white}";
        };

        bright = {
          black = "#${theme.ansi.brightBlack}";
          red = "#${theme.ansi.brightRed}";
          green = "#${theme.ansi.brightGreen}";
          yellow = "#${theme.ansi.brightYellow}";
          blue = "#${theme.ansi.brightBlue}";
          magenta = "#${theme.ansi.brightMagenta}";
          cyan = "#${theme.ansi.brightCyan}";
          white = "#${theme.ansi.brightWhite}";
        };

        indexed_colors = [
          # { index = 16; color = "#${theme.orange}"; }
          # { index = 17; color = "#${theme.brown}"; }
          # { index = 18; color = "#${theme.backgroundAlt}"; }
          # { index = 19; color = "#${theme.selectionBg}"; }
          # { index = 20; color = "#${theme.foregroundAlt}"; }
          # { index = 21; color = "#${theme.foregroundBright}"; }
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

