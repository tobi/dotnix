{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:

# Framework Laptop 13 AMD AI 300 Series Configuration
#
# Hardware configuration inherited from nixos-hardware (inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series):
# - AMD GPU drivers (hardware.graphics.enable, hardware.amdgpu.initrd.enable)
# - AMD P-State driver for better power management
# - amdgpu.dcdebugmask=0x10 kernel parameter (disables panel self-refresh to prevent hangs)
# - Power profiles daemon (services.power-profiles-daemon.enable)
# - Latest kernel requirement (boot.kernelPackages = pkgs.linuxPackages_latest when kernel < 6.15)
# - fwupd firmware updates (services.fwupd.enable)
#
# This file contains machine-specific overrides and additional configuration.

let
  resumeOffset = 3250851;
in
{
  system.stateVersion = "25.11";

  time.timeZone = "America/Toronto";

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

    # Latest kernel for power management and suspend fixes
    # NOTE: Also set by nixos-hardware when kernel < 6.15, but we keep it explicit
    kernelPackages = pkgs.linuxPackages_latest;

    kernel.sysctl = {
      "kernel.dmesg_restrict" = 0; # Allow non-root dmesg access
    };

    # Resume from the decrypted btrfs device (not the LUKS container)
    resumeDevice = "/dev/disk/by-uuid/8fa74c8c-9891-4a7e-9b48-b5dfa6016a32";

    # Enable hibernation (Plymouth adds nohibernate by default)
    kernelParams = [
      "quiet"
      "boot.shell_on_fail"
      "rd.systemd.show_status=auto"
      "rd.udev.log_level=3"
      "vt.global_cursor_default=0"

      # NOTE: amdgpu.dcdebugmask=0x10 is set by nixos-hardware to prevent display hangs
      # Do not override it here!

      # Enable AMD P-State (redundant with nixos-hardware but explicit for documentation)
      "amd_pstate=active"

      # Disable btusb autosuspend for WebAuthn BLE reliability
      "btusb.enable_autosuspend=0"

      # Apple Pro Display XDR - ignore broken HID interfaces
      # The display has malformed HID descriptors causing disconnect loop
      # HID_QUIRK_IGNORE (0x00000004) tells kernel to ignore HID, display still works
      "usbhid.quirks=0x05ac:0x9243:0x00000004"

      # Hibernation support - resume offset for btrfs swap file
      "resume_offset=${toString (resumeOffset + 0)}"
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
  services.udev.packages = [
    pkgs.libfido2
    pkgs.bolt
  ];
  services.udev.extraRules = ''
    # MediaTek MT7922 Bluetooth adapter for WebAuthn hybrid transport
    # Framework AMD laptop - allows Chrome/Chromium to use BLE for passkeys
    # Uses uaccess tag for systemd-logind dynamic ACLs (follows libfido2 pattern)
    # SUBSYSTEM=="usb", ATTRS{idVendor}=="0e8d", ATTRS{idProduct}=="0717", TAG+="uaccess", GROUP="plugdev", MODE="0660"

    # Keep MediaTek BT awake, no autosuspend
    # ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0e8d", TEST=="power/control", ATTR{power/control}="on"

    # Disable PCIe port wakeups to prevent spurious wakes during s2idle
    # ACTION=="add", SUBSYSTEM=="pci", DRIVER=="pcieport", ATTR{power/wakeup}="disabled"
  '';

  # Services
  services = {
    flatpak.enable = true;
    blueman.enable = true;
    seatd.enable = true;
    logind = {
      extraConfig = ''
        HandlePowerKey=suspend-then-hibernate
        HandleLidSwitch=suspend-then-hibernate
        HandleLidSwitchExternalPower=suspend-then-hibernate
        HibernateDelaySec=2h
      '';
    };

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
    hardware.bolt.enable = true; # Thunderbolt device authorization (needed for Apple Pro Display XDR)

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

  # Disable zram - using real swap file for hibernation support
  zramSwap.enable = lib.mkForce false;

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

    # Disable protectKernelImage to allow hibernation
    # NOTE: This security feature prevents kernel replacement but blocks hibernation
    protectKernelImage = lib.mkForce false;
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
    e2fsprogs
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
