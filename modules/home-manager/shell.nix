{ pkgs, lib }:
let
  inherit (pkgs.stdenv) isLinux;
in
{
  aliases = {
    # Editor and tools
    n = "nvim";
    devshell = "nix develop ~/dotnix --impure";
    lg = "${pkgs.lazygit}/bin/lazygit";
    gs = "${pkgs.git}/bin/git status";
    bat = "${pkgs.bat}/bin/bat";
    sg = "${pkgs.ast-grep}/bin/ast-grep";
    rg = "${pkgs.ripgrep}/bin/rg";
    t = "try";

    # GRC colorized commands
    ping = "${pkgs.grc}/bin/grc --colour=auto ping";
    traceroute = "${pkgs.grc}/bin/grc --colour=auto traceroute";
    make = "${pkgs.grc}/bin/grc --colour=auto make";
    diff = "${pkgs.grc}/bin/grc --colour=auto diff";
    dig = "${pkgs.grc}/bin/grc --colour=auto dig";
    mount = "${pkgs.grc}/bin/grc --colour=auto mount";
    ps = "${pkgs.grc}/bin/grc --colour=auto ps";
    df = "${pkgs.grc}/bin/grc --colour=auto df";
    ifconfig = "${pkgs.grc}/bin/grc --colour=auto ifconfig";
    netstat = "${pkgs.grc}/bin/grc --colour=auto netstat";

    # File operations
    ".." = "cd ..";
    ls = "${pkgs.eza}/bin/eza";
    ll = "${pkgs.eza}/bin/eza -l";
    la = "${pkgs.eza}/bin/eza -a";
    lla = "${pkgs.eza}/bin/eza -la";
    tree = "${pkgs.eza}/bin/eza --tree";

    # clipboard
    c = "pbcopy";
    v = "pbpaste";
  }
  // lib.optionalAttrs isLinux {
    # Clipboard (macOS compatibility on Linux)
    pbcopy = "${pkgs.wl-clipboard}/bin/wl-copy";
    pbpaste = "${pkgs.wl-clipboard}/bin/wl-paste";
  };

  # Packages needed for aliases to work
  packages = with pkgs; [
    lazygit
    git
    bat
    ast-grep
    ripgrep
    grc
    eza
  ];

  # Bash-specific init
  bashInit = ''
    set -o emacs
    export PATH="$HOME/.local/bin:$HOME/dotnix/bin:$PATH"
    export DOTFILES="$HOME/dotnix"
  '';

  # Zsh-specific init
  zshInit = ''
    bindkey '^[[1;5C' forward-word      # Ctrl+Right
    bindkey '^[[1;5D' backward-word     # Ctrl+Left
    bindkey '^[[1;3C' forward-word      # Alt+Right (alternative)
    bindkey '^[[1;3D' backward-word     # Alt+Left (alternative)
    bindkey '^[[H' beginning-of-line    # Home key
    bindkey '^[[F' end-of-line          # End key

    export PATH="$HOME/.local/bin:$HOME/dotnix/bin:$PATH"
    export DOTFILES="$HOME/dotnix"
  '';
}
