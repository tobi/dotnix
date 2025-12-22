{
  description = "Tobi's home-manager configuration";

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      # Support both Linux and Darwin
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      # Generate pkgs for each system with overlays
      mkPkgs =
        system:
        import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            allowUnfreePredicate = _: true;
          };
          overlays = [
            inputs.niri.overlays.niri
          ];
        };

      # Helper to create home configuration
      mkHomeConfig =
        {
          system,
          username ? "tobi",
          extraModules ? [ ],
        }:
        let
          pkgs = mkPkgs system;
          isLinux = pkgs.stdenv.isLinux;
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs;
          };
          modules = [
            # Import shared theme module
            ../theme
            # Import nix-colors for home-manager
            inputs.nix-colors.homeManagerModules.default
            # Configure theme and wm settings
            {
              dotnix = {
                wm = "hyprland";
                theme = {
                  name = "catppuccin-mocha";
                  font = "Inter";
                  variant = "light";
                  wallpaper = "1.jpg";
                };
              };
            }
            # Base home configuration
            ./home.nix
          ]
          # Desktop environment (Linux only)
          ++ nixpkgs.lib.optionals isLinux [ ./desktop.nix ]
          ++ extraModules;
        };
    in
    {
      # Home Manager configurations
      homeConfigurations = {
        # Linux x86_64 configuration
        "tobi@x86_64" = mkHomeConfig { system = "x86_64-linux"; };

        # macOS aarch64 configuration
        "tobi@arm64" = mkHomeConfig { system = "aarch64-darwin"; };
        "tobi@aarch64" = mkHomeConfig { system = "aarch64-darwin"; };
      };

      formatter = nixpkgs.lib.genAttrs systems (
        system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style
      );
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    niri.url = "github:sodiboo/niri-flake";
    niri.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";

    nix-colors.url = "github:misterio77/nix-colors";

    try.url = "github:tobi/try-cli";
    try.inputs.nixpkgs.follows = "nixpkgs";

    ghostty.url = "github:ghostty-org/ghostty";
    ghostty.inputs.nixpkgs.follows = "nixpkgs";
  };
}
