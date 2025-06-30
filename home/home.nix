{ config, pkgs, lib, ... }:
let
  username = "tobi";
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
  isWsl = builtins.pathExists "/proc/sys/fs/binfmt_misc/WSLInterop";
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
    # CPPFLAGS = "-I${pkgs.zlib.dev}/include -I${pkgs.openssl.dev}/include -I${pkgs.libffi.dev}/include";
    # LDFLAGS = "-L${pkgs.zlib.out}/lib -L${pkgs.openssl.out}/lib -L${pkgs.libffi.out}/lib";
    MANPAGER = "sh -c 'col -bx | ${pkgs.bat}/bin/bat -l man -p'";

  } // lib.optionalAttrs isDarwin {
    # macOS specific environment variables
  };



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
    cowsay

    # System tools
    htop
    sysz
    mtr
    fswatch
    zstd

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
    comma
    duckdb
    ffmpeg
    pv
    killall

    # Nice-to-have
    gum
    neofetch
    fortune
    bat-extras.batgrep
    bat-extras.batman
    bat-extras.batdiff
    # bat-extras
  ] ++ lib.optionals isLinux [
    # Linux-specific packages
    # nvidia-docker  # NVIDIA container runtime
    # qemu


  ] ++ lib.optionals isDarwin [
    # Darwin-specific packages (if any)
  ];

  # Git configuration
  programs.git = {
    enable = true;
    userName = "Tobi Lütke";
    userEmail = "tobi@lutke.com";
    extraConfig.init.defaultBranch = "main";
  };

  # Editor setup
  programs.micro = {
    enable = true;
    settings.clipboard = "terminal";
    settings.tabsize = 2;
    settings.tabstospaces = true;
  };

  # Essential tools
  programs.bat = {
    enable = true;
    config.tabs = "2";
  };

  programs.fzf = {
    enable = true;
    defaultCommand = "fd --type f";
    defaultOptions = [ "--height 75%" "--border" "--preview 'bat --color=always --style=numbers --line-range=:500 {}'" ];
    fileWidgetCommand = "fd --type f";
    changeDirWidgetCommand = "fd --type d";
    changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];
  };

  # Shell configuration
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Interactive shell setup
    initContent = ''
      # ── Ctrl-← / Ctrl-→ word jumps ────────────────────────────
      # Ghostty sends CSI 1;5D / 1;5C; map them to the usual widgets.
      bindkey -M emacs '\e[1;5D' backward-word
      bindkey -M emacs '\e[1;5C' forward-word
      unset zle_bracketed_paste
      zle -D bracketed-paste
      bindkey -r '\e[200~'
      bindkey -r '\e[201~'

      echo
      export PATH="$HOME/bin:$HOME/.local/bin:$HOME/dotnix/home/bin:${lib.optionalString isDarwin ":/opt/dev/bin"}:$PATH"

      [ -f ~/.zshrc.local ] && echo "* Adding ~/.zshrc.local" && source ~/.zshrc.local

      # Load environment variables and show fortune
      echo && ${pkgs.fortune}/bin/fortune -s
    '';

    history.size = 10000;
    # initExtra = ''
    #   # disable bracketed paste
    #   bindkey -e
    #   zle_bracketed_paste_plain() { zle .bracketed-paste }
    #   # to turn off bracketed paste support
    #   zle -N bracketed-paste
    # '';

    shellAliases = {
      # Editor and tools
      e = "nano";
      lg = "lazygit";
      sudo = "sudo -Es";

      # Enhanced commands
      #cat = "bat -p";
      #grep = "batgrep";
      #diff = "batdiff";
      #man = "batman";

      # File operations
      ls = "eza --group-directories-first";
      ll = "eza -l --group-directories-first";
      la = "eza -a --group-directories-first";
      lla = "eza -la --group-directories-first";
      tree = "eza --tree --group-directories-first";
      ".." = "cd ..";

      # Git shortcuts
      gs = "git status";
      gc = "git commit -m";
      gd = "git diff";
      gdc = "git diff --cached";

      # Development
      b = "bundle exec";

      # System management
      reload = "nix develop ~/dotnix/flake.nix -c home-manager switch --flake ~/dotnix/home/flake.nix && source $HOME/.zshrc";
    };
  };

  # Simplified starship prompt with proper integration
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;

    settings = {
      add_newline = true;
      command_timeout = 200;
      format = "[$username$hostname](light blue) $directory$character";
      right_format = "$git_branch$git_status$cmd_duration$python$ruby";

      username = {
        show_always = true;
        format = "[$user]($style)";
        style_user = "blue";
        style_root = "red bold";
      };

      hostname = {
        ssh_only = true;
        format = "$ssh_symbol$hostname";
      };

      directory = {
        truncation_length = 2;
        truncation_symbol = "…/";
      };

      character = {
        success_symbol = "[❯](bold #A5D6A7)[❯](bold #FFF59D)[❯](bold #FFAB91)";
        error_symbol = "[✗](bold red)";
      };

      # Disable unused modules
      git_metrics.disabled = true;
      gcloud.disabled = true;
      package.disabled = true;
    };
  };

  programs.mise = {
    enable = true;
    enableZshIntegration = true;
    settings.legacy_version_file = true; # read .tool-versions
    globalConfig.tools.bun = "latest";
    globalConfig.tools.uv = "latest";
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

  programs.btop.enable = true;
  programs.yazi.enable = true;

  # xdg.configFile."ghostty/config".source = ./config/ghostty.config;
}
