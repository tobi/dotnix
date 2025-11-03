{ pkgs, ... }:

{
  imports = [
    ./envs.nix
    ./input.nix
    ./outputs.nix
    ./layout.nix
    ./binds.nix
    ./startup.nix
    ./window-rules.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    # plugins = [
    #   # hyprtrails disabled - incompatible with Hyprland 0.49.0
    # ];
  };

  services.hyprpolkitagent.enable = true;
}
