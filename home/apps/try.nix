{ inputs, ... }:
{
  imports = [
    inputs.try.homeModules.default
  ];

  programs.try = {
    enable = true;
    path = "~/src/tries";
  };
}
