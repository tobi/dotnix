{ pkgs, ... }:

{

  system.stateVersion = "25.11";

  time.timeZone = "America/Toronto";

  # Networking
  networking.hostName = "beetralisk";

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
      theme = "hexagon_dots_alt";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = [
            "cuts"
            "hexagon_dots_alt"
            "deus_ex"
          ];
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
      allowedTCPPorts = [
        22
        53317
      ]; # SSH and LocalSend
      allowedUDPPorts = [ 53317 ]; # LocalSend
    };
  };

  # Add ZRAM for better memory management
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 40;
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

    upower.enable = true;
    thermald.enable = true;
    fwupd.enable = true;

    # Tailscale, this is needed for exit notes to work
    tailscale.enable = true;
    tailscale.useRoutingFeatures = "client";
  };

  # Security
  security = {
    pam.services.greetd.enableGnomeKeyring = true;
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
        default = [
          "wlr"
          "gtk"
        ];
      };
      niri = {
        default = [
          "wlr"
          "gtk"
        ];
        "org.freedesktop.impl.portal.Camera" = [ "gtk" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
      };
    };
  };

  # System Packages
  environment.systemPackages = with pkgs; [
    # Core tools
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

    # Applications
    chromium

    # File management
    nautilus
    gparted
    file-roller

    # System tools
    zip
    p7zip

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

    # Package management
    nix-index

    # Tailscale
    tailscale
  ];

}
