/*
  Common NixOS Configuration

  Features:
  - Shared NixOS settings used across all machines
  - Nix configuration and optimization
  - System-wide packages and services
  - Security and performance settings

  This module contains configuration that is common to all NixOS machines
  and helps reduce duplication across machine-specific configurations.
*/

{ config
, lib
, pkgs
, ...
}:

{

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Nix Settings - Common across all machines
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;

    # Performance optimizations
    download-buffer-size = 2147483648; # 2GB
    max-jobs = "auto";
    cores = 0; # Use all cores

    # Binary cache configuration for better performance
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://devenv.cachix.org"
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  # Nix garbage collection - Common across all machines
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
    dates = "weekly";
  };

  # Common system packages
  environment.systemPackages =
    with pkgs;
    [
      # Core utilities
      git
      curl
      wget
      htop
      tree
      file
      which
      rsync
      lsof
      iotop
      sysz
      dust
      mprocs
      pv
      killall
      home-manager

      # System tools
      vim
      nano
      pciutils
      usbutils
      bind.dnsutils
      nmap
      traceroute
      iperf3
    ]
    ++ lib.optionals config.dotnix.desktop.enable [
      # Desktop-specific packages
      pavucontrol
      wireplumber
      v4l-utils
      cheese
      pipewire
      bluez
      bluez-tools
      pcsclite
      libfido2
      iw
      wirelesstools
    ];

  # Common programs
  programs = {
    nix-ld.enable = true;
    fuse.userAllowOther = lib.mkIf config.dotnix.desktop.enable true;
    appimage = {
      enable = lib.mkIf config.dotnix.desktop.enable true;
      binfmt = lib.mkIf config.dotnix.desktop.enable true;
    };
  };

  # Common services
  services.chrony.enable = lib.mkIf (!config.boot.isContainer) true;

  # Fix NTP startup dependencies
  systemd.services.chronyd = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
  };

  # Common fonts - only needed for desktop environments
  fonts.packages = lib.mkIf config.dotnix.desktop.enable (
    with pkgs;
    [
      inter
      noto-fonts
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
      freetype
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.caskaydia-mono
      nerd-fonts.symbols-only
    ]
  );

  # Common security settings
  security = {
    rtkit.enable = lib.mkIf config.dotnix.desktop.enable true;

    # Additional security hardening
    protectKernelImage = true;
    lockKernelModules = false; # Allow loading kernel modules
    allowSimultaneousMultithreading = true;
    unprivilegedUsernsClone = true;
  };

  # Common networking
  networking.firewall = {
    enable = true;
    rejectPackets = true;
  };

  # Networking defaults (overridable per-machine)
  # - Laptops/desktops typically use NetworkManager (set in machine config)
  # - Containers may use systemd-networkd (set in `modules/nixos/proxmox.nix`)
  networking.useDHCP = lib.mkDefault true;
  networking.useNetworkd = lib.mkDefault false;
  systemd.network.enable = lib.mkDefault false;

  # System optimizations
  services = {
    # EarlyOOM to prevent system lockup
    earlyoom.enable = true;

    # Cron for scheduled tasks
    cron.enable = true;

    # System monitoring
    sysstat.enable = true;
  };

  # ZRAM for better memory management
  zramSwap = if config.dotnix.desktop.enable then {
    enable = true;
    algorithm = "zstd";
    memoryPercent = lib.mkDefault 50;
  } else {
    enable = false;
  };

  # Common boot settings
  boot = {
    tmp.useTmpfs = lib.mkIf config.dotnix.desktop.enable true;
    tmp.tmpfsSize = lib.mkIf config.dotnix.desktop.enable "50%";

    # Additional boot optimizations
    kernel.sysctl = {
      "vm.swappiness" = 10; # Reduce swap usage
      "vm.dirty_ratio" = 10; # Reduce dirty page cache
      "vm.dirty_background_ratio" = 5;
    };
  };

  # Common environment variables
  environment.sessionVariables = lib.mkIf config.dotnix.home.enable {
    DOTFILES = "$HOME/dotnix";
  };

  environment.variables = {
    EDITOR = "nano";
    VISUAL = "nano";
  };
}
