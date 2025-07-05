{ pkgs, ... }:
{
  home.packages = with pkgs; [
    steam
  ];

  # config has to be in configuration.nix due to system deps
}
