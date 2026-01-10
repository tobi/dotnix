{ pkgs, ... }:
{
  # Install the walker launcher when selected
  home.packages = [
    pkgs.walker
    pkgs.libqalculate # Enables walker's calculator feature
  ];

  services.walker.enable = true;
}
