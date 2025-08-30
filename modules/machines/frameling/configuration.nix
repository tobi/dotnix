{ pkgs, inputs, config, ... }:

{
  system.stateVersion = "25.11";

  time.timeZone = "America/Toronto";

  # Networking
  networking = {
    networkmanager.enable = true;
    firewall = {
      allowedTCPPorts = [ 22 ]; # SSH only
      allowedUDPPorts = [ ];    # No UDP ports by default
    };
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
      "amdgpu.dcdebugmask=0" # Disable GPU debug mask
    ];

    # Configure initrd for smoother LUKS prompt
    initrd = {
      verbose = true;
      systemd.enable = true;
    };
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        KernelExperimental = true;
      };
    };
  };

  # Enable Bluetooth LE Audio support
  systemd.user.services.pipewire.environment.PIPEWIRE_LATENCY = "128/48000";
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    extraConfig.pipewire."91-bluetooth-le" = {
      "context.modules" = [
        {
          name = "libpipewire-module-bluez5-codec-lc3plus";
          args = { };
        }
      ];
    };
  };

  # Programs
  programs.nix-ld.enable = true;
  programs.fuse.userAllowOther = true;
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  # Create plugdev group for U2F/FIDO2 devices
  users.groups.plugdev = { };

  # Udev rules for FIDO2/WebAuthn devices
  services.udev.packages = [ pkgs.libfido2 ];

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

    # Tailscale, this is needed for exit notes to to work
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

  # Assertions for better error messages
  assertions = [
    {
      assertion = config.dotnix.desktop.enable -> config.programs.niri.enable;
      message = "Desktop environment requires Niri window manager to be enabled";
    }
    {
      assertion = config.networking.hostName != "";
      message = "Hostname must be set for this machine";
    }
  ];
}