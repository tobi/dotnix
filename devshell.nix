{ nixpkgs, system }:
let
  pkgs = import nixpkgs { inherit system; };
  # Choose the Ruby version you want to build
in
{
  # import the dev pkgs from ruby and python compilation
  packages.${system}.default = [
    pkgs.ruby_3_4
    pkgs.python313
  ];

  # Create a development shell with the packages from devshell.toml
  devShells.${system}.default = pkgs.mkShell {
    buildInputs = with pkgs; [
      # Core packages
      nano
      micro
      home-manager
      curl
      wget

          # Development tools
      gnumake
      stdenv.cc
      llvm
      zlib.dev
      openssl.dev
      libffi.dev
      pkg-config
      libyaml.dev
      autoconf
      automake
      libtool
      libuuid

      # Nix development tools
      nixpkgs-fmt
      statix
      deadnix

      # Language runtimes
      ruby_3_4
      python313
      starship
      zsh
    ];

    shellHook = ''
      # Initialize starship for the current shell
      if [[ -n "$ZSH_VERSION" ]]; then
        eval "$(starship init zsh)"
      else
        eval "$(starship init bash)"
      fi
      
      echo "Ruby version: $(ruby --version)"
      echo "Python version: $(python --version)"
      echo "🚀 Development shell activated, you can now compile things"
    '';

    # Prefer zsh as the shell
    preferLocalBuild = true;
    shell = "${pkgs.zsh}/bin/zsh";
  };
}

