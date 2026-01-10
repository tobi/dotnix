# Git Server (Proxmox LXC Container)
{ ... }:

{
  imports = [
    ./configuration.nix
    ../../nixos/common.nix
    ../../nixos/user.nix
    ../../nixos/proxmox.nix
    ../../nixos/services
  ];

  networking.hostName = "git";

  dotnix = {
    home.enable = false;
    desktop.enable = false;

    services = {
      tailscale = {
        enable = true;
        ssh = true;
      };
      nginx.enable = true;
      forgejo.enable = true;
      # Domain auto-derived as git.tail250b8.ts.net from hostname + tailnetDomain
    };
  };
}
