# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, nixos-wsl, ... }:
{
  imports = [
    # include NixOS-WSL modules
    nixos-wsl.nixosModules.wsl
  ];

  networking.hostName = "zerg-wsl2";

  # ───── Core Nix settings ────────────────────────────────────────────────
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store   = true;          # deduplicate after builds
  };

  # Allow proprietary editors (VS Code, Cursor)
  nixpkgs.config.allowUnfree = true;

  # ───── User Configuration ──────────────────────────────────────────────
  users.users.tobi = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ]; # Enable 'sudo' for the user
  };

  # Enable zsh system-wide
  programs.zsh.enable = true;

  # ───── WSL Configuration ────────────────────────────────────────────────
  wsl.enable = true;
  wsl.defaultUser = "tobi";
  wsl.startMenuLaunchers = true;
  
  
  # Set default directory to user's home
  wsl.wslConf.user.default = "tobi";

  # ───── NVIDIA GPU Support for WSL2 ─────────────────────────────────────
  # Enable NVIDIA drivers and container toolkit
  hardware = {
    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = false;  # Don't need GUI settings in WSL
      open = false;            # Use proprietary drivers
    };
    nvidia-container-toolkit.enable = true;
  };

  # Set video drivers
  services.xserver.videoDrivers = [ "nvidia" ];

  # Add NVIDIA packages to system
  environment.systemPackages = with pkgs; [
    vscode 
    # cursor
    # NVIDIA tools
    nvidia-docker
    linuxPackages.nvidia_x11  # NVIDIA kernel module
  ];

  # Environment variables for WSL2 NVIDIA support
  environment.variables = {
    # Point to WSL2 NVIDIA libraries
    LD_LIBRARY_PATH = "/usr/lib/wsl/lib";
    # Ensure CUDA libraries are found
    CUDA_PATH = "/usr/lib/wsl";
  };

  # ───── Fallback libs for binary blobs ──────────────────────────────────
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # Standard libraries for dynamic linking
      stdenv.cc.cc.lib
      zlib
      freeglut
      libGL
      libGLU
      xorg.libX11
      xorg.libXext
      xorg.libXi
      xorg.libXrandr
      xorg.libXrender
      xorg.libXxf86vm
      # NVIDIA specific libraries
      linuxPackages.nvidia_x11
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}

