{ pkgs, lib, inputs, ... }:
let
  username = "tobi";
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in
{
  # Basic home configuration
  programs.home-manager.enable = true;

  home.stateVersion = "25.05";
  home.username = username;
  home.homeDirectory =
    if pkgs.stdenv.isDarwin
    then "/Users/${username}"
    else "/home/${username}";


  # Global environment variables
  home.sessionVariables = {
    DOTFILES = "$HOME/dotnix";
    MANPAGER = "sh -c 'col -bx | ${pkgs.bat}/bin/bat -l man -p'";
  };

  # Git configuration
  programs.git = {
    enable = true;
    userName = "Tobi Lütke";
    userEmail = "tobi@lutke.com";

    # SSH commit signing
    signing = {
      key = "~/.ssh/id_ed25519.pub";
      signByDefault = true;
    };

    extraConfig = {
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
    };
  };

  programs.micro = {
    enable = true;
    settings.clipboard = "terminal";
    settings.tabsize = 2;
    settings.tabstospaces = true;
  };

  programs.fzf = {
    enable = true;
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [ "--height 75%" "--border" ];
    fileWidgetCommand = "fd --type f";
    changeDirWidgetCommand = "fd --type d";
    changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];
  };

  # Shell configuration
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history.size = 50000;

    # Interactive shell setup
    initContent = ''
      # ── Ctrl-← / Ctrl-→ word jumps ────────────────────────────
      # Ghostty sends CSI 1;5D / 1;5C; map them to the usual widgets.
      bindkey -M emacs '^[[1;5D' backward-word
      bindkey -M emacs '^[[1;5C' forward-word

      echo
      export PATH="$HOME/bin:$HOME/.local/bin:$HOME/dotnix/bin:${lib.optionalString isDarwin ":/opt/dev/bin"}:$PATH"

      # Trial function - creates trial directory and cd's into it
      trial() {
        local trial_dir
        trial_dir=$($HOME/dotnix/bin/trial "$@")
        if [[ -n "$trial_dir" && -d "$trial_dir" ]]; then
          cd "$trial_dir"
        fi
      }

      [ -f ~/.zshrc.local ] && echo "* Adding ~/.zshrc.local" && source ~/.zshrc.local

      # Show system info on shell startup
      echo && ${lib.optionalString isLinux "nitch"}
    '';


    shellAliases = {
      # Editor and tools
      e = "nano";
      lg = "lazygit";

      # File operations
      ls = "eza";
      ll = "eza -l";
      la = "eza -a";
      lla = "eza -la";
      tree = "eza --tree";
      ".." = "cd ..";

      # Git shortcuts
      gs = "git status";
      gc = "git commit -m";
      gd = "git diff";
      gdc = "git diff --cached";

    } // lib.optionalAttrs pkgs.stdenv.isLinux {
      # Clipboard (macOS compatibility on Linux)
      pbcopy = "wl-copy";
      pbpaste = "wl-paste";
    };
  };

  # Global shell aliases (will be overridden by desktop.nix when present)
  home.shellAliases = {
    # System management
    reload = lib.mkDefault "home-manager switch --flake ~/dotnix#tobi && source $HOME/.zshrc";
    switch = lib.mkDefault "home-manager switch --flake ~/dotnix#tobi && source $HOME/.zshrc";
  };

  programs.mise = {
    enable = true;
    enableZshIntegration = true;
  };

  # Enable additional tools with proper integrations
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.eza = {
    enable = true;
    icons = "always";
    extraOptions = [ "--group-directories-first" ];
  };

  programs.btop.enable = true;
  programs.yazi.enable = true;

  imports = [
    ./apps/starship.nix
  ];

  # Essential packages organized by category
  home.packages = with pkgs; [
    # Core utilities
    fd
    bat
    fzf
    eza
    ripgrep
    wget
    curl
    jq
    age
    gh
    fswatch
    zstd

    # System tools
    htop
    sysz
    mtr
    dust
    yazi
    mprocs
    mask
    pv
    killall

    # Development
    gnumake
    sqlite
    zlib.dev
    stdenv.cc
    openssl.dev
    libffi.dev
    pkg-config
    lazygit
    hyperfine
    tokei
    nixpkgs-fmt
    nixfmt-rfc-style
    nixfmt-tree
    comma
    duckdb
    ffmpeg


    # Nice-to-have
    gum
    bat-extras.batgrep
    bat-extras.batman
    bat-extras.batdiff

  ] ++ lib.optionals isLinux [
    sysz
    nitch
  ];

}
