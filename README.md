# Dotfiles in Nix

* `home/*` home-manager dotfile configuration
* `machines/*` - configuration.nix for homelab boxes

## to use

* have nix installed
* run `NIX_CONFIG="experimental-features nix-command flakes" nix develop`
* run `switch` to setup the machine or `apply` to setup dotfiles. Make sure that the machine's hostname is known to the flakes