{ ... }:
{
  programs.git = {
    enable = true;

    # SSH commit signing
    signing = {
      key = "~/.ssh/id_ed25519.pub";
      signByDefault = true;
    };

    ignores = [
      # OS
      ".DS_Store"
      "Thumbs.db"

      # Editors/IDEs
      ".idea/"
      ".vscode/"
      "*.swp"
      "*.swo"
      "*~"

      # Languages/tools
      "node_modules"
      "__pycache__/"
      ".venv"
      ".direnv/"
      ".devenv/"

      # Build/env
      ".builder"
      ".env"
      ".env.local"

      # Tools
      "*.local.json"
    ];

    settings = {
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      user.name = "Tobi Lütke";
      user.email = "tobi@lutke.com";
      include.path = "~/.config/dev/gitconfig";
      credential."https://github.com".helper = "!gh auth git-credential";
      credential."https://gist.github.com".helper = "!gh auth git-credential";
    };
  };
}
