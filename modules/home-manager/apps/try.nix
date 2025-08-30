{ pkgs, inputs, ... }:
{
  imports = [
    inputs.try.homeManagerModules.default
  ];
  
  programs.try = {
    enable = true;
    path = "~/src/tries";
  };
}
