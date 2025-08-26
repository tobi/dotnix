{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    # package = pkgs.neovim;
    # add lazyvim
    plugins = with pkgs.vimPlugins; [
      lazy-nvim
    ];
  };

}
