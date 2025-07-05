# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    # include NixOS-WSL modules
    inputs.nixos-wsl.nixosModules.wsl

    # base it on determinate nixos
    inputs.determinate.nixosModules.default

    # user configuration
    ../user.nix
  ];

  networking.hostName = "zerg-wsl2";

  # ───── Core Nix settings ────────────────────────────────────────────────
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true; # deduplicate after builds
  };

  # ───── WSL Configuration ────────────────────────────────────────────────
  wsl.enable = true;
  wsl.defaultUser = "tobi";
  wsl.startMenuLaunchers = true;

  # WSL configuration options
  wsl.wslConf = {
    automount.root = "/mnt";
    network.generateHosts = false;
    user.default = "tobi";
  };

  # Set timezone to fix warnings
  time.timeZone = "America/New_York";

  # ───── NVIDIA GPU Support for WSL2 ─────────────────────────────────────
  # WSL2 uses Windows NVIDIA drivers, so we don't need Linux drivers
  # Just ensure we can access the GPU through WSL2's passthrough

  # Enable container toolkit for Docker GPU support
  hardware.nvidia-container-toolkit = {
    enable = true;
    # WSL2 provides NVIDIA drivers, so suppress the assertion
    suppressNvidiaDriverAssertion = true;
  };

  # Add basic packages - CUDA tools are provided by WSL2
  environment.systemPackages = with pkgs; [
    vscode
    # cursor
    # Docker for containers (NVIDIA runtime provided by WSL2)
    docker

    # Fix missing commands from diagnostics
    tzdata # Fix timezone warnings
    pciutils # lspci
    usbutils # lsusb
  ];

  # Environment variables for WSL2 NVIDIA support
  environment.sessionVariables = {
    # Point to WSL2 NVIDIA libraries
    LD_LIBRARY_PATH = "/usr/lib/wsl/lib";
    # Ensure CUDA libraries are found
    CUDA_PATH = "/usr/lib/wsl";
  };

  # Add nvidia-smi alias for easy access
  programs.bash.shellAliases = {
    nvidia-smi = "/usr/lib/wsl/lib/nvidia-smi";
  };
  programs.zsh.shellAliases = {
    nvidia-smi = "/usr/lib/wsl/lib/nvidia-smi";
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
      # WSL2 provides NVIDIA libraries at /usr/lib/wsl/lib
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

