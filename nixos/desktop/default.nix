/*
  Desktop Environment - NixOS System Configuration

  This module bundles all system-level desktop configuration.
  All sub-modules are gated by `config.dotnix.desktop.enable`.

  Includes:
  - Hyprland compositor and display manager
  - Audio (PipeWire)
  - Authentication (1Password, fingerprint)
  - Desktop environment variables
*/

{
  imports = [
    ./hyprland.nix
    ./audio.nix
    ./authentication.nix
    ./environment.nix
  ];
}
