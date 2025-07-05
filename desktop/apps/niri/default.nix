{ theme
, pkgs
, ...
}:
let
  palette = theme.palette;
in
{

  programs.niri = {
    enable = true;
    config = builtins.readFile ../../../config/niri/config.kdl;

    # settings = (import ./settings.nix { inherit config palette; });
  };

  # Cursor themes for niri
  home.packages = with pkgs; [
    bibata-cursors
    capitaine-cursors
    graphite-cursors
    numix-cursor-theme
  ];
}
