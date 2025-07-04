{ ... }:

{
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
      # git_metrics.disabled = true;
      # gcloud.disabled = true;
      # package.disabled = true;
    };
  };
}
