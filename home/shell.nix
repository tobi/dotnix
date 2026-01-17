{ pkgs, lib }:
let
  inherit (pkgs.stdenv) isLinux;
in
{
  aliases = {
    # Editor and tools
    n = "${pkgs.neovim}/bin/nvim";
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

    # Ctrl+X prefix menu with help (uses right prompt area)
    ctrl-x-menu() {
      local saved_rprompt="$RPROMPT"
      RPROMPT=$'%F{yellow}b%f%F{242}undle %f%F{yellow}m%f%F{242}ise %f%F{yellow}s%f%F{242}udo%f %F{242}│%f %F{cyan}l%f%F{242}bat %f%F{cyan}c%f%F{242}opy %f%F{cyan}j%f%F{242}q %f%F{cyan}g%f%F{242}rep%f %F{242}│%f %F{magenta}&%f%F{242}bq%f'
      zle reset-prompt
      read -k 1 key
      RPROMPT="$saved_rprompt"
      zle reset-prompt
      case $key in
        b) BUFFER="bundle exec $BUFFER" ;;
        m) BUFFER="mise exec -- $BUFFER" ;;
        s) BUFFER="sudo $BUFFER" ;;
        w) BUFFER="watch -n1 $BUFFER" ;;
        t) BUFFER="time $BUFFER" ;;
        l) BUFFER="$BUFFER | bat" ;;
        c) BUFFER="$BUFFER | pbcopy" ;;
        j) BUFFER="$BUFFER | jq '.. | select(.KEY? == \"VALUE\")'" ;;
        g) BUFFER="$BUFFER | rg " ;;
        h) BUFFER="$BUFFER | head -20" ;;
        q) BUFFER="$BUFFER > /dev/null 2>&1" ;;
        '&') BUFFER="bq $BUFFER" ;;
      esac
      CURSOR=$#BUFFER
      zle redisplay
    }
    zle -N ctrl-x-menu
    bindkey '^X' ctrl-x-menu

    export PATH="$HOME/.local/bin:$HOME/dotnix/bin:$PATH"
    export DOTFILES="$HOME/dotnix"

    # Run command in zellij "bq" (background queue) session
    bq() {
      local zj="$HOME/.nix-profile/bin/zellij"
      local cmd_path=$(which "$1" 2>/dev/null || echo "$1")
      local hash=$(echo "$cmd_path:$PWD" | md5sum | cut -c1-5)
      local pane_name="''${1##*/}:$hash"

      # Ensure bq session exists (create in background if not)
      $zj attach -cb bq 2>/dev/null

      # Run command in bq session
      $zj -s bq action new-pane --name "$pane_name" --cwd "$PWD" -- "$@"
    }
  '';
}
