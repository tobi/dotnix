{ pkgs, inputs, config, ... }:

{

  system.stateVersion = "25.11";

  time.timeZone = "America/Toronto";

  # Networking
  networking.hostName = "beetralisk";

  # Nix Settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
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
      systemd-boot.configurationLimit = 6;
      efi.canTouchEfiVariables = true;
    };

    # Quiet boot configuration
    consoleLogLevel = 3;

    # Plymouth for graphical boot
    plymouth = {
      enable = true;
      theme = "cuts";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "cuts" "hexagon_dots" ];
        })
      ];
    };

    # we need latest kernel for modern AMD hardware
    kernelPackages = pkgs.linuxPackages_latest;

    kernel.sysctl = {
      "kernel.dmesg_restrict" = 0; # Allow non-root dmesg access
    };
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "rd.systemd.show_status=auto"
      "rd.udev.log_level=3"
      "vt.global_cursor_default=0"
    ];

    # Configure initrd for smoother LUKS prompt
    initrd = {
      verbose = true;
      systemd.enable = true; # Use systemd in initrd for better Plymouth integration
    };
  };

  # Hardware
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Experimental = true;
    };

    # Enable firmware updates
    enableRedistributableFirmware = true;

    # Graphics configuration for AMD Radeon 780M
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  # Networking
  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ]; # SSH
      allowedUDPPorts = [ ];
    };
  };

  # Add ZRAM for better memory management
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 40;
  };

  # Programs
  programs = {
    nix-ld.enable = true;
    fuse.userAllowOther = true;
  };


  # Create plugdev group for U2F/FIDO2 devices
  users.groups.plugdev = { };

  # Udev rules for FIDO2/WebAuthn devices
  services.udev.packages = [ pkgs.libfido2 ];

  # Services
  services = {
    flatpak.enable = true;
    blueman.enable = true;
    seatd.enable = true;
    openssh.enable = true;
    printing.enable = true;
    chrony.enable = true;
    upower.enable = true;
    thermald.enable = true;
    fwupd.enable = true;

    # Tailscale, this is needed for exit notes to work
    tailscale.enable = true;
    tailscale.useRoutingFeatures = "client";
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

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;

    # Fix font rendering issues
    extraCompatPackages = with pkgs; [
      liberation_ttf
      wqy_zenhei
      vistafonts
    ];

    # Add 32-bit libraries including video codecs
    extraPackages = with pkgs; [
      libgdiplus
      ffmpeg
      libva
      libvdpau
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-ugly
      gst_all_1.gst-libav
      gst_all_1.gst-vaapi
    ];
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
        default = [ "wlr" "gtk" ];
      };
      niri = {
        default = [ "wlr" "gtk" ];
        "org.freedesktop.impl.portal.Camera" = [ "gtk" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
      };
    };
  };

  # System Packages
  environment.systemPackages = with pkgs; [
    # Core tools
    git
    zsh
    bash
    fuse
    xdg-user-dirs # Fix Steam xdg-user-dir warnings

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

  # Fonts
  fonts.packages = with pkgs; [
    inter
    noto-fonts
    noto-fonts-emoji
    noto-fonts-cjk-sans

    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.caskaydia-mono
    nerd-fonts.symbols-only
  ];
}

