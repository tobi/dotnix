{ ... }:

{
  # Niri configuration - modular structure
  # Each sub-module contributes to programs.niri.settings
  imports = [
    ./input.nix
    ./cursor.nix
    ./outputs.nix
    ./layout.nix
    ./startup.nix
    ./animations.nix
    ./window-rules.nix
    ./binds.nix
    ./misc.nix
  ];
}
