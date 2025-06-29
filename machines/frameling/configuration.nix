{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # System Configuration
  networking.hostName = "frameling";
  time.timeZone = "America/Toronto";
  system.stateVersion = "25.11";

  # Nix Settings
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    lazy-trees = true;
  };

  # Boot Configuration
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      # AMD CPU optimizations
      "amd_pstate=active"
      "amd_iommu=on"
      "initcall_debug"

      # AMD GPU optimizations for Radeon 860M
      "amdgpu.dpm=1"
      "amdgpu.gpu_recovery=1"
      "amdgpu.dc=1"
      "amdgpu.freesync_video=1"
      "amdgpu.ppfeaturemask=0xffffffff"

      # Power and thermal management
      "mem_sleep_default=deep"
      "processor.max_cstate=9"
      "intel_idle.max_cstate=9"

      # Security features
      "mitigations=auto,nosmt"
      "spectre_v2=on"
      "spec_store_bypass_disable=on"

      # Audio optimizations
      "snd_hda_intel.power_save=1"
      "snd_hda_intel.probe_mask=1"
    ];
    extraModprobeConfig = ''
      options snd_hda_intel model=auto
    '';
    extraModulePackages = [ ];
    kernelModules = [ "uinput" ];
  };

  # Networking
  networking.networkmanager.enable = true;

  # Hardware Configuration
  hardware = {
    enableAllFirmware = true;
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
    cpuFreqGovernor = "schedutil";
  };

  # Programs
  programs = {
    niri.enable = true;
    xwayland.enable = true;
    nix-ld.enable = true;
    zsh.enable = true;

    fuse.userAllowOther = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession.enable = true;
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
    gparted
    file-roller

    # System tools
    htop
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
  ];



  # Display Manager
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "niri-session";
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
    pcscd.enable = true; # Smart card and FIDO2 support
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
  };

  # Security
  security = {
    rtkit.enable = true;
    pam.services.greetd.enableGnomeKeyring = true;
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

  # User Account
  users.users.tobi = {
    isNormalUser = true;
    description = "Tobi";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "video" "render" "input" "gamemode" "bluetooth" ];
    initialHashedPassword = "";
  };
}
