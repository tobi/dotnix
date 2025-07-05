{ nix-colors, ... }:
let
  name = "tokyo-night-dark";
  variant = "dark";
  colorScheme = nix-colors.colorSchemes.${name};
in
{
  inherit name variant;
  palette = colorScheme.palette;
}
