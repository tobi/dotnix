{ inputs, ... }:

{
  # Install per-output layout KDL file to niri config directory
  xdg.configFile."niri/per-output-layout.kdl".source = ../../../../../config/niri/per-output-layout.kdl;

  # Add include statement to load per-output layout overrides
  # This allows us to use raw KDL for features not yet supported in niri-flake
  programs.niri.config = with inputs.niri.lib.kdl; [
    (node "include" "per-output-layout.kdl" [ ])
  ];
}
