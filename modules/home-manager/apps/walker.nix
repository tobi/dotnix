{ pkgs, ... }:
{
  # Install the walker launcher when selected
  home.packages = [ pkgs.walker ];

  services.walker.enable = true;
}
