# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ pkgs, ... }:
{

  networking.hostName = "zerg-wsl2";

  # ───── WSL Configuration ────────────────────────────────────────────────
  wsl = {
    enable = true;
    defaultUser = "tobi";
    startMenuLaunchers = true;

    # WSL configuration options
    wslConf = {
      automount.root = "/mnt";
      network.generateHosts = false;
      user.default = "tobi";
    };
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
  ];

  # Environment variables for WSL2 NVIDIA support
  environment.sessionVariables = {
    # Point to WSL2 NVIDIA libraries
    LD_LIBRARY_PATH = "/usr/lib/wsl/lib";
    # Ensure CUDA libraries are found
    CUDA_PATH = "/usr/lib/wsl";
  };

  # Programs
  programs = {
    # Add nvidia-smi alias for easy access
    bash.shellAliases = {
      nvidia-smi = "/usr/lib/wsl/lib/nvidia-smi";
    };
    zsh.shellAliases = {
      nvidia-smi = "/usr/lib/wsl/lib/nvidia-smi";
    };

    # ───── Fallback libs for binary blobs ──────────────────────────────────
    nix-ld = {
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
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
