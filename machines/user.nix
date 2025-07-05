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
    description = "Tobi";
  };

  # Enable zsh system-wide since it's the user's shell
  programs.zsh.enable = true;

  # Home-manager configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    backupFileExtension = "backup";

    # Set an empty password for the live environment
    initialHashedPassword = "";
    # Add your public SSH key for convenience
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO+bCR59gv82AsYtmVxZM3Tu+AvIjmjbMI3mHiqo+DFJ"
    ];

    users.tobi.imports = modules-home ++ [
      nix-colors.homeManagerModules.default
      niri.homeModules.niri
    ];

    extraSpecialArgs = {
      inherit theme inputs;
    };
  };
}
