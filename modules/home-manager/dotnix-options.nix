{ config, lib, pkgs, ... }:

let
  # Generate command scripts for hotkeys that have a cmd defined
  generateCmdScripts = hotkeys:
    lib.mapAttrs'
      (key: cfg:
        lib.nameValuePair ".local/bin/${cfg.cmd}" {
          text =
            if cfg.focusClass != null
            then ''
              #!/usr/bin/env bash
              exec ${../../bin/open-or-focus} "${cfg.focusClass}" "${cfg.executable}" $@
            ''
            else ''
              #!/usr/bin/env bash
              exec ${../../bin/open} "${cfg.executable}" $@
            '';
          executable = true;
        }
      )
      (lib.filterAttrs (key: cfg: cfg.cmd != null) hotkeys);
in
{
  options.dotnix.desktop.hotkeys = lib.mkOption {
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
        cmd = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Optional command name to create a CLI script in PATH that executes the open-or-focus logic";
        };
      };
    });
    default = { };
    description = "Application hotkey bindings for open-or-focus functionality";
  };

  config.home.file = generateCmdScripts config.dotnix.desktop.hotkeys;
}

