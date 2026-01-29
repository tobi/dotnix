{
  pkgs,
  lib,
  ...
}:
let
  username = "tobi";
  inherit (pkgs.stdenv) isDarwin;
  inherit (pkgs.stdenv) isLinux;
  shell = import ./shell.nix { inherit pkgs lib; };
in
{
  # Basic home configuration
  home = {
    stateVersion = "25.05";
    # enableNixpkgsReleaseCheck = false;
    inherit username;
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";

    # Ensure home-manager bin is in PATH (needed for standalone HM on NixOS)
    sessionPath = [ "$HOME/.nix-profile/bin:$HOME" ];

    # Global environment variables
    sessionVariables = {
      DOTFILES = "$HOME/dotnix";
      # EDITOR = "nvim";
    };
  };

  # Allow application launchers to discover apps in ~/Applications
  # xdg.systemDirs.data = lib.optionals isLinux [
  #   "${config.home.homeDirectory}/Applications"
  # ];

  programs = {
    home-manager.enable = true;

    bat = {
      enable = true;
      config.theme = "OneHalfDark";
    };

    # Git configuration
    git = {
      enable = true;
      # SSH commit signing
      signing = {
        key = "~/.ssh/id_ed25519.pub";
        signByDefault = true;
      };

      settings = {
        gpg.format = "ssh";
        gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
        user.name = "Tobi Lütke";
        user.email = "tobi@lutke.com";
        include.path = [
          "~/.config/dev/gitconfig"
          "~/.gitconfig"
        ];
        credential."https://github.com".helper = "!gh auth git-credential";
        credential."https://gist.github.com".helper = "!gh auth git-credential";
      };
    };

    micro = {
      enable = true;
      settings = {
        clipboard = "terminal";
        tabsize = 2;
        tabstospaces = true;
      };
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      defaultCommand = "fd --type f --hidden --follow --exclude .git";
      defaultOptions = [
        "--height 75%"
        "--border"
      ];
      fileWidgetCommand = "fd --type f";
      changeDirWidgetCommand = "fd --type d";
      changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];
    };

    # Shell configuration
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      history.size = 50000;
      defaultKeymap = "emacs";

      # Interactive shell setup
      initContent = ''
        ${shell.zshInit}

        # -- Local zshrc ────────────────────────────────────────────
        [ -f ~/.zshrc.local ] && source ~/.zshrc.local
      '';
    };

    bash = {
      enable = true;
      enableCompletion = true;
      historySize = 50000;
      historyControl = [ "erasedups" "ignoredups" "ignorespace" ];

      initExtra = ''
        ${shell.bashInit}

        # -- Local bashrc ───────────────────────────────────────────
        [ -f ~/.bashrc.local ] && source ~/.bashrc.local
      '';
    };
  };

  home.shellAliases = {
    # update home-manager or nixos
    switch = "switch && source $HOME/.zshrc";
  } // shell.aliases;

  programs.mise = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  # Enable additional tools with proper integrations
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
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
    ./apps/neovim.nix
    ./apps/try.nix
  ];

  # Essential packages organized by category
  home.packages =
    with pkgs;
    [
      # ── Core utilities ──────────────────────────────────────────────────
      age # Simple, modern and secure file encryption
      bat # Cat clone with syntax highlighting
      bc # Arbitrary precision calculator
      curl # Command line tool for transferring data
      eza # Modern replacement for ls
      fd # Simple, fast and user-friendly find
      fswatch # File change monitor
      fzf # General-purpose command-line fuzzy finder
      gh # GitHub CLI tool
      grc # Generic text colouriser
      jq # Lightweight and flexible JSON processor
      ripgrep # Fast text search tool
      wget # Network utility to retrieve files
      zstd # Fast compression algorithm

      # ── System tools ────────────────────────────────────────────────────
      dust # More intuitive version of du
      htop # Interactive process viewer
      killall # Kill processes by name
      mask # CLI task runner defined by a simple markdown file
      mprocs # Run multiple commands in parallel
      mtr # Network diagnostic tool
      procs # Modern replacement for ps
      pv # Terminal-based tool for monitoring data
      sysz # System information tool
      yazi # Terminal file manager

      # ── Development tools ───────────────────────────────────────────────
      ast-grep # Fast structural search and replace
      comma # Runs programs without installing them
      duckdb # Analytical database
      envsubst # Substitute environment variables in shell format
      ffmpeg # Multimedia framework
      gnumake # GNU make utility
      hyperfine # Command-line benchmarking tool
      lazygit # Simple terminal UI for git
      libffi.dev # Foreign function interface library
      nixfmt-rfc-style # Nix code formatter (RFC style)
      nixfmt-tree # Nix code formatter (tree style)
      nixpkgs-fmt # Nix code formatter
      openssl.dev # Cryptography and SSL/TLS toolkit
      shellcheck # Static analysis tool for shell scripts
      pkg-config # Helper tool for compiling applications
      sqlite # SQL database engine
      stdenv.cc # C/C++ compiler toolchain
      tokei # Count your code, quickly
      unzip # ZIP archive extraction utility
      zlib.dev # Compression library
      zsync # File synchronization tool
      zellij # Terminal multiplexer
      git-lfs # Git Large File Storage
      socat # Multipurpose relay
      netcat-gnu # Network utility
      glow

      # ── Nice-to-have utilities ───────────────────────────────────────────
      fastfetch # Fast system information tool
      gum # Tool for glamorous shell scripts
      gcalcli # Google Calendar CLI
      rclone

    ]
    ++ lib.optionals isLinux [
      nitch # Minimal system information tool
      sysz # System information tool
    ]
    ++ lib.optionals isDarwin [
    ];

  programs.try = {
    enable = true;
    path = "~/src/tries";
  };
}
