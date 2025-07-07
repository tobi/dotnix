{ config, pkgs, lib, home-manager, modulesPath, inputs, ... }:

{
  imports = [
    # Use the base installation CD module instead of the non-existent graphical one
    (modulesPath + "/installer/cd-dvd/installation-cd-base.nix")
    # Enable persistent storage overlay for USB drives
    (modulesPath + "/installer/cd-dvd/iso-image.nix")

    # user configuration
    ../user.nix

    # base it on determinate nixos
    inputs.determinate.nixosModules.default
  ];

  # ISO image settings
  isoImage.isoName = "nixos-usb-stick-tobi.iso";
  isoImage.squashfsCompression = "zstd";

  # Include the dotnix directory in the ISO
  isoImage.contents = [
    {
      source = ./../..;
      target = "/dotnix";
    }
  ];

  # Allow proprietary software like NVIDIA drivers
  # NOTE: allowUnfree is already set in lib/common.nix

  # Basic system settings
  networking.hostName = "nixos-live";
  networking.networkmanager.enable = true;
  # Disable wireless to avoid conflicts with NetworkManager
  networking.wireless.enable = lib.mkForce false;
  time.timeZone = "America/New_York";

  # Boot configuration to handle hardware issues
  boot.kernelParams = [
    # Disable problematic audio codec detection that can hang boot
    "snd_hda_intel.probe_mask=1"
    # Audio fallback parameters
    "snd_hda_intel.power_save=0"
    # NVIDIA specific parameters
    "nvidia-drm.modeset=1"
  ];

  boot.extraModprobeConfig = ''
    options snd_hda_intel model=auto
  '';

  # Kernel modules
  boot.extraModulePackages = [ ];
  boot.blacklistedKernelModules = [
    # Blacklist problematic audio modules that can cause boot hangs
    "snd_pcsp"
  ];

  # Hyprland window manager and display setup (Wayland-only)
  programs.hyprland = {
    enable = true;
    xwayland.enable = true; # Keep for compatibility with some apps
  };

  # Auto-login to Hyprland using greetd (Wayland-native display manager)
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "Hyprland";
        user = "tobi";
      };
    };
  };

  # Required for Wayland and portals
  security.rtkit.enable = true;
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # NVIDIA driver configuration for Wayland
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    # Use the proprietary driver
    open = false;
    # Install the stable NVIDIA driver package
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    # Power management (helps with compatibility)
    powerManagement.enable = true;
    # Force composition pipeline to avoid issues
    forceFullCompositionPipeline = true;
  };


  # Add useful packages to the live environment
  environment.systemPackages = with pkgs; [
    git
    kitty # Wayland-native terminal
    ghostty # Wayland-native terminal
    fuzzel # Wayland launcher (better than wofi)
    chromium # Chromium-style browser
    waybar # Wayland status bar
    swww # Wayland wallpaper daemon
    grim # Wayland screenshot tool
    slurp # Screen area selection for Wayland
    wl-clipboard # Wayland clipboard utilities
    wlr-randr # Monitor configuration for wlroots
    kanshi # Dynamic display configuration
    anyrun # Application launcher
    # anyrun-with-all-plugins # Application launcher with all plugins
    # File management
    gparted
    file-roller
    # System tools
    htop
    neofetch
    # Audio
    pavucontrol
    wireplumber
  ];

  programs.zsh.enable = true; # Enable zsh



  # Enable sound with Pipewire (fixed deprecated option)
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    # Add better hardware compatibility
    extraConfig.pipewire."92-low-latency" = {
      context.properties = {
        default.clock.rate = 48000;
        default.clock.quantum = 32;
        default.clock.min-quantum = 32;
        default.clock.max-quantum = 32;
      };
    };
  };

  # Set fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
  ];


  # Home Manager configuration with version check disabled
  # Copy dotnix to user home directory on boot
  systemd.services.copy-dotnix = {
    description = "Copy dotnix to user home directory";
    after = [ "home-manager-tobi.service" ];
    serviceConfig = {
      Type = "oneshot";
      User = "tobi";
      Group = "users";
      ExecStart = "${pkgs.bash}/bin/bash -c 'if [ ! -d /home/tobi/dotnix ]; then cp -r /dotnix /home/tobi/dotnix && chown -R tobi:users /home/tobi/dotnix; fi'";
      RemainAfterExit = true;
    };
    wantedBy = [ "multi-user.target" ];
  };

  # Home-manager configuration is now handled in flake.nix

  hardware.enableAllFirmware = true;


  # Set the NixOS release version
  system.stateVersion = "25.11";
}
