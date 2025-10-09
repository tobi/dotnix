{ config, lib, ... }:

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
      };
    });
    default = {};
    description = "Application hotkey bindings for open-or-focus functionality";
  };
}
