{ pkgs, modules-home ? [ ], home-manager, niri, nix-colors, theme, inputs, ... }:
{
  imports = [
    home-manager.nixosModules.home-manager
  ];

  # User configuration
  users.users.tobi = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "docker" "render" "input" "gamemode" "bluetooth" "plugdev" "libvirtd" ];
    description = "Tobi Lutke";
  };

  # Enable zsh system-wide since it's the user's shell
  programs.zsh.enable = true;

  # Home-manager configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    
    users.tobi.imports = modules-home ++ [
      nix-colors.homeManagerModules.default
      niri.homeModules.niri
    ];

    extraSpecialArgs = {
      inherit theme inputs;
    };
  };
}
