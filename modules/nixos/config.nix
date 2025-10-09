{ config, lib, pkgs, ... }:

{
  imports = [
    ./theme.nix
  ];

  options.dotnix = {
    home = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable dotnix home configuration";
      };
    };

    desktop = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable dotnix desktop configuration";
      };

      assertions = [
        (lib.hm.assertions.assertPlatform "dotnix.desktop only works on NixOS" pkgs lib.platforms.nixos)
        (lib.hm.assertions.assertPlatform "dotnix.desktop only works on Linux" pkgs lib.platforms.linux)
      ];

      hotkeys = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule {
          options = {
            executable = lib.mkOption {
              type = lib.types.str;
              description = "The executable name to launch or focus";
            };
            focusClass = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "The window class to match for focus. If null, only opens the app without focus logic.";
            };
          };
        });
        default = {};
        description = "Application hotkey bindings for open-or-focus functionality";
        example = lib.literalExpression ''
          {
            "Super+S" = {
              executable = "Slack";
              focusClass = "chrome-app.slack.com__client-Default";
            };
            "Super+A" = {
              executable = "ChatGPT";
              focusClass = "chrome-chat.openai.com__-Default";
            };
          }
        '';
      };
    };
  };

}

