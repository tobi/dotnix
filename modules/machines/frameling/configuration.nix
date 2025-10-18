{ pkgs, inputs, config, ... }:

{
  imports = [
    ../../nixos/wifi-fixes.nix
  ];

  system.stateVersion = "25.11";

  time.timeZone = "America/Toronto";

  # Networking
  networking = {
    networkmanager.enable = true;
    firewall = {
      allowedTCPPorts = [ 22 ]; # SSH only
      allowedUDPPorts = [ ]; # No UDP ports by default
    };
  };

  # Boot Configuration
  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.consoleMode = "max";
      systemd-boot.configurationLimit = 6;
      efi.canTouchEfiVariables = true;
    };

    # Quiet boot configuration
    consoleLogLevel = 3;

    # Plymouth for graphical boot
    plymouth = {
      enable = true;
      theme = "bgrt";
    };

    # we need latest kernel to deal with power issues
    kernelPackages = pkgs.linuxPackages_latest;

    kernel.sysctl = {
      "kernel.dmesg_restrict" = 0; # Allow non-root dmesg access
    };

    kernelParams = [
      "quiet"
      "boot.shell_on_fail"
      "rd.systemd.show_status=auto"
      "rd.udev.log_level=3"
      "vt.global_cursor_default=0"

      # Disable GPU debug mask
      "amdgpu.dcdebugmask=0"

      # Enable AMD P-State
      "amd_pstate=active"

      # Disable btusb autosuspend for WebAuthn BLE reliability
      "btusb.enable_autosuspend=0"

      # Apple Pro Display XDR - ignore broken HID interfaces
      # The display has malformed HID descriptors causing disconnect loop
      # HID_QUIRK_IGNORE (0x00000004) tells kernel to ignore HID, display still works
      "usbhid.quirks=0x05ac:0x9243:0x00000004"
    ];

    # Configure initrd for smoother LUKS prompt
    initrd = {
      verbose = true;
      systemd.enable = true;
    };
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
          ControllerMode = "dual";
          Privacy = "device";
          KernelExperimental = true; # Enable LE Audio and other experimental features
        };
        Policy = {
          AutoEnable = "true";
        };
      };
    };

    enableRedistributableFirmware = true;
  };


  # Programs
  programs.nix-ld.enable = true;
  programs.fuse.userAllowOther = true;
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  # Create plugdev group for U2F/FIDO2 devices
  users.groups.plugdev = { };

  # FIDO2/WebAuthn and Bluetooth device access
  services.udev.packages = [ pkgs.libfido2 pkgs.bolt ];
  services.udev.extraRules = ''
    # MediaTek MT7922 Bluetooth adapter for WebAuthn hybrid transport
    # Framework AMD laptop - allows Chrome/Chromium to use BLE for passkeys
    # Uses uaccess tag for systemd-logind dynamic ACLs (follows libfido2 pattern)
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0e8d", ATTRS{idProduct}=="0717", TAG+="uaccess", GROUP="plugdev", MODE="0660"

    # Keep MediaTek BT awake, no autosuspend
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0e8d", TEST=="power/control", ATTR{power/control}="on"

    # Disable PCIe port wakeups to prevent spurious wakes during s2idle
    ACTION=="add", SUBSYSTEM=="pci", DRIVER=="pcieport", ATTR{power/wakeup}="disabled"
  '';

  # Services
  services = {
    flatpak.enable = true;
    blueman.enable = true;
    seatd.enable = true;

    # SSH with security hardening
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        X11Forwarding = false;
      };
    };

    printing.enable = true;
    chrony.enable = true;
    upower.enable = true;
    thermald.enable = true;
    fwupd.enable = true;
    hardware.bolt.enable = true;

    # Tailscale, this is needed for exit notes to to work
    tailscale.enable = true;
    tailscale.useRoutingFeatures = "client";
  };

  # Virtualization
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  # Fix NTP startup dependencies
  systemd.services.chronyd = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
  };
  systemd.services.bluetooth.serviceConfig.ExecStart = [
    ""
    "${pkgs.bluez}/libexec/bluetooth/bluetoothd -f /etc/bluetooth/main.conf --experimental"
  ];

  # Power Management - Optimized for Framework AMD s2idle
  powerManagement = {
    enable = true;
    scsiLinkPolicy = "med_power_with_dipm";

    resumeCommands = ''
      # Log resume events for debugging
      echo "$(date): System resumed from suspend" >> /var/log/suspend-resume.log
    '';
  };

  # Systemd sleep configuration - use suspend-then-hibernate
  systemd.sleep.extraConfig = ''
    # Hibernate after 2 hours of suspend to prevent battery drain
    HibernateDelaySec=2h
    AllowHybridSleep=yes
    AllowSuspendThenHibernate=yes
  '';

  # Security
  security = {
    pam.services.greetd.enableGnomeKeyring = true;

    # Enable apparmor
    apparmor.enable = true;
  };

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
    protontricks.enable = true;

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
      kopia
      kopia-ui
      restic
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
    zsh
    bash
    xdg-user-dirs

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
    nss.tools
    openssl
    bzip2
    netcat-openbsd
    jq

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

    # Tailscale
    tailscale
  ];

  # Udisks2 for automounting USB devices
  services.udisks2.enable = true;

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

