{ pkgs, inputs, ... }:

{
  imports = [
    # hardware configuration
    ./hardware-configuration.nix

    # user configuration
    ../user.nix

    # base it on determinate nixos
    inputs.determinate.nixosModules.default

    # use nixos-hardware package to get everything
    # dialed in for the framework laptop instead of doing it outselves.
    #
    inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
  ];

  # System Configuration
  networking.hostName = "frameling";
  time.timeZone = "America/Toronto";

  system.stateVersion = "25.11";

  # Nix Settings
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

    # we need latest kernel to deal with power issues
    kernelPackages = pkgs.linuxPackages_latest;

    kernel.sysctl = {
      "kernel.dmesg_restrict" = 0; # Allow non-root dmesg access
      "vm.swappiness" = 10; # Reduce swap usage
    };
  };

  # Environment variables for proper GUI app support
  environment.sessionVariables = {
    # Ensure GUI apps work with Wayland (with X11 fallback)
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_STYLE_OVERRIDE = "kvantum";

    # Wayland-specific settings
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    SDL_VIDEODRIVER = "wayland";
    WAYLAND_DISPLAY = "wayland-1";
    OZONE_PLATFORM = "wayland";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
  };

  # Security wrapper for GUI ap
  security.polkit.enable = true;
  security.sudo.extraConfig = ''
    Defaults env_keep += "WAYLAND_DISPLAY XDG_RUNTIME_DIR XDG_SESSION_TYPE GDK_BACKEND QT_QPA_PLATFORM"
  '';

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
    niri.enable = true;
    xwayland.enable = true;
    nix-ld.enable = true;
    dconf.enable = true;
    fuse.userAllowOther = true;
  };

  # Display Manager
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "niri --session --config /home/tobi/dotnix/config/niri/config.kdl";
        user = "tobi";
      };
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
    openssh.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
    tailscale.enable = true;
    printing.enable = true;
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


  # Fonts
  fonts.packages = with pkgs; [
    inter
    maple-mono
    maple-mono-nerd
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    noto-fonts
    noto-fonts-emoji
    nerd-fonts.caskaydia-mono
  ];
}
