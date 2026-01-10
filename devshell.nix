{ nixpkgs, system, inputs }:
let
  pkgs = import nixpkgs { inherit system; };
  lib = pkgs.lib;
  shell = import ./home/shell.nix { inherit pkgs lib; };

  # Convert aliases attrset to bash alias commands
  aliasLines = lib.mapAttrsToList (name: value: "alias ${name}=${lib.escapeShellArg value}") shell.aliases;
  aliasScript = lib.concatStringsSep "\n" aliasLines;

in
{
  packages.${system}.default = [
    pkgs.ruby_3_4
    pkgs.python313
  ];

  # Create a development shell with the packages from devshell.toml
  devShells.${system} = {
    default = pkgs.mkShell {
      buildInputs = with pkgs; [
        # Core packages
        nano
        micro
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
      ] ++ shell.packages;

      shellHook = ''
        ${shell.bashInit}

        # Aliases from shell.nix
        ${aliasScript}

        # Init starship and try
        eval "$(starship init bash)"

        echo "Ruby version: $(ruby --version)"
        echo "Python version: $(python --version)"
        echo "🚀 Development shell activated, you can now compile things"
      '';
    };
  };
}
