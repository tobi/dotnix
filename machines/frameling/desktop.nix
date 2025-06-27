{ config, pkgs, lib, home-manager, modulesPath, ... }:

{
  imports = [
  ];

  # Allow proprietary software like NVIDIA drivers
  nixpkgs.config.allowUnfree = true;

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

  # User account for auto-login
  users.users.tobi = {
    isNormalUser = true;
    description = "Tobi";
    shell = pkgs.zsh;
    # Add user to necessary groups for hardware access and admin rights
    extraGroups = [ "wheel" "networkmanager" "video" "render" "adbusers" ];
    # Set an empty password for the live environment
    initialHashedPassword = "";
    # Add your public SSH key for convenience
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO+bCR59gv82AsYtmVxZM3Tu+AvIjmjbMI3mHiqo+DFJ"
    ];
  };

  # Hyprland window manager and display setup (Wayland-only)
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;  # Keep for compatibility with some apps
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
    kitty          # Wayland-native terminal
    ghostty        # Wayland-native terminal
    fuzzel         # Wayland launcher (better than wofi)
    chromium       # Chromium-style browser
    waybar         # Wayland status bar
    swww           # Wayland wallpaper daemon
    grim           # Wayland screenshot tool
    slurp          # Screen area selection for Wayland
    wl-clipboard   # Wayland clipboard utilities
    wlr-randr      # Monitor configuration for wlroots
    kanshi         # Dynamic display configuration
    anyrun         # Application launcher
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

  hardware.enableAllFirmware = true;
  

  # Set the NixOS release version
  system.stateVersion = "25.05";
} 
