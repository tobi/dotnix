/*
  Redirect HM-managed dotfiles to ~/.config/dotnix/ so the actual
  dotfiles (~/.zshrc etc.) stay as regular files that tools can modify.
  The apply script seeds/checks the user files for the right includes.
*/
{ config, lib, ... }:
let
  d = ".config/dotnix";
  zshrc = config.home.file."./.zshrc".source;
  zshenv = config.home.file."./.zshenv".source;
  bashrc = config.home.file.".bashrc".source;
  bashprof = config.home.file.".bash_profile".source;
  gitconf = config.xdg.configFile."git/config".text;
in
{
  # Disable HM's default placements
  home.file."./.zshrc".enable = lib.mkForce false;
  home.file."./.zshenv".enable = lib.mkForce false;
  home.file.".bashrc".enable = lib.mkForce false;
  home.file.".bash_profile".enable = lib.mkForce false;
  xdg.configFile."git/config".enable = lib.mkForce false;

  # Write to ~/.config/dotnix/ (dotted originals + convenience symlinks)
  home.file."${d}/.zshrc".source = zshrc;
  home.file."${d}/zshrc".source = zshrc;
  home.file."${d}/.zshenv".source = zshenv;
  home.file."${d}/zshenv".source = zshenv;
  home.file."${d}/.bashrc".source = bashrc;
  home.file."${d}/bashrc".source = bashrc;
  home.file."${d}/.bash_profile".source = bashprof;
  home.file."${d}/bash_profile".source = bashprof;
  home.file."${d}/.gitconfig".text = gitconf;
  home.file."${d}/gitconfig".text = gitconf;
}
