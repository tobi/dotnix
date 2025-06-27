            {
  inputs = {
    # This is pointing to an unstable release.
    # If you prefer a stable release instead, you can this to the latest number shown here: https://nixos.org/download
    # i.e. nixos-24.11
    # Use `nix flake update` to update the flake to the latest revision of the chosen release channel.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    niri.url = "github:sodiboo/niri-flake";

  };
  outputs = inputs@{ self, nixpkgs, ... }:
   {
    overlays = [ inputs.niri.overlays.niri ];
    programs.niri.package = nixpkgs.niri-unstable;

  
    # NOTE: 'nixos' is the default hostname
    nixosConfigurations.frameling = nixpkgs.lib.nixosSystem {
      modules = [ 
	      ./configuration.nix 
        ./desktop.nix
      ];
    };
  };
}

