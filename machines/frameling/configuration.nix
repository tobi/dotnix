{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # System Configuration
  networking.hostName = "frameling";
  time.timeZone = "America/Toronto";
  system.stateVersion = "25.05";

  # Nix Settings
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    lazy-trees = true;
  };

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
    dates = "weekly";
  };

  # Boot Configuration
  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.consoleMode = "2"; # First non-standard mode - higher resolution
      systemd-boot.configurationLimit = 10;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      # Set framebuffer to native resolution for better visibility
      "video=eDP-1:2256x1504@60"

      # AMD CPU optimizations
      "amd_pstate=guided"
      "amd_iommu=on"

      # AMD GPU optimizations for Radeon 860M
      "amdgpu.dpm=1"
      "amdgpu.gpu_recovery=1"
      "amdgpu.dc=1"
      "amdgpu.freesync_video=1"
      "amdgpu.ppfeaturemask=0xfffffeff"

      # Power and thermal management
      "mem_sleep_default=s2idle"
      "processor.max_cstate=2"

      # USB/Bluetooth fixes
      "xhci_hcd.quirks=0x00000040"

      # PCIe power management - allow but fix error reporting
      "pci=noaer"

      # ZSWAP compressed swap
      "zswap.enabled=1"

      # Security features
      "mitigations=auto,nosmt"

      # Audio optimizations
      "snd_hda_intel.power_save=1"
      "snd_hda_intel.probe_mask=1"
    ];

    kernel.sysctl = {
      "kernel.dmesg_restrict" = 0; # Allow non-root dmesg access
      "vm.swappiness" = 10; # Reduce swap usage
    };

    extraModprobeConfig = ''
      options snd_hda_intel model=auto
    '';
    extraModulePackages = [ ];
    kernelModules = [ "uinput" ];
  };

  # Console configuration for high DPI display
  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";
    packages = with pkgs; [ terminus_font ];
  };

  # Networking
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ]; # SSH
    allowedUDPPorts = [ ];
  };

  # Hardware Configuration
  hardware = {
    enableAllFirmware = true;
    firmware = [ pkgs.linux-firmware ];
    cpu.amd.updateMicrocode = true;
    amdgpu = {
      initrd.enable = true;
      opencl.enable = true;
      amdvlk.enable = true;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        amdvlk
        driversi686Linux.amdvlk
        rocmPackages.clr.icd
      ];
    };
  };

  # Power Management
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  # Add ZRAM for better memory management
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  # Backlight control
  hardware.acpilight.enable = true;

  # Set default brightness to 60% on boot
  systemd.services.brightness-default = {
    description = "Set default brightness to 60%";
    wantedBy = [ "multi-user.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.brightnessctl}/bin/brightnessctl set 60%";
      RemainAfterExit = true;
    };
  };

  # Programs
  programs = {
    niri.enable = true;
    xwayland.enable = true;
    nix-ld.enable = true;
    zsh.enable = true;
    dconf.enable = true;

    fuse.userAllowOther = true;
  };

  # System Packages
  environment.systemPackages = with pkgs; [
    # Core tools
    git
    zsh
    bash
    fuse

    # Terminals
    kitty
    ghostty
    alacritty

    # Wayland tools
    fuzzel
    waybar
    swww
    grim
    slurp
    wl-clipboard
    wlr-randr
    kanshi
    anyrun
    xwayland-satellite
    pciutils
    usbutils

    # Applications
    chromium

    # File management
    nautilus
    gparted
    file-roller

    # System tools
    vim
    nano
    tree
    zip
    p7zip
    file
    which
    lsof
    rsync
    htop
    iotop
    neofetch

    # Audio
    pavucontrol
    wireplumber

    # Camera support and debugging
    v4l-utils
    cheese
    pipewire

    # Bluetooth and WebAuthn support
    bluez
    bluez-tools

    # FIDO2/WebAuthn support
    pcsclite
    libfido2

    # Network tools
    bind.dnsutils # dig, nslookup
    nmap
    traceroute
    iperf3

    # Package management
    nix-index

    # Tailscale
    tailscale
  ];

  # Display Manager
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "niri-session";
        user = "tobi";
      };
      # Environment variables can be set in the initial_session_environment
      initial_session_environment = [
        "NIRI_CONFIG=/home/tobi/dotnix/desktop/niri/config.kdl"
      ];
    };
  };

  # Udev rules for FIDO2/WebAuthn devices
  services.udev.packages = [ pkgs.libfido2 ];

  # Services
  services = {
    flatpak.enable = true;
    blueman.enable = true;
    dbus.enable = true;
    gnome.gnome-keyring.enable = true;
    power-profiles-daemon.enable = true;
    pulseaudio.enable = false;
    seatd.enable = true;
    pcscd.enable = true; # Smart card and FIDO2 support
    openssh.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
      extraConfig.pipewire."92-low-latency" = {
        context.properties = {
          default.clock.rate = 48000;
          default.clock.quantum = 32;
          default.clock.min-quantum = 32;
          default.clock.max-quantum = 32;
        };
      };
    };
    pipewire.wireplumber.enable = true;
    tailscale.enable = true;
    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    chrony.enable = true;
    upower.enable = true;
    thermald.enable = true;
    fwupd.enable = true;
  };

  # Fix NTP startup dependencies
  systemd.services.chronyd = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
  };

  # Security
  security = {
    rtkit.enable = true;
    pam.services.greetd.enableGnomeKeyring = true;
  };

  # Appimage support
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
  };

  # XDG Portals
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;

    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = [ "wlr" ];
      };
      niri = {
        default = [ "wlr" "gtk" ];
        "org.freedesktop.impl.portal.Camera" = [ "gtk" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
      };
    };
  };

  # Fonts
  fonts.packages = with pkgs; [
    inter
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
  ];

  # Groups
  users.groups.plugdev = { };

  # User Account
  users.users.tobi = {
    isNormalUser = true;
    description = "Tobi";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "video" "render" "input" "gamemode" "bluetooth" "plugdev" ];
    # Set password using: sudo passwd tobi
    # Or generate hash with: mkpasswd -m sha-512
    hashedPassword = null; # Will prompt to set password on first login
  };
}
