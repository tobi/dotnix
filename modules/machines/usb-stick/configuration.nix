{ config, pkgs, lib, home-manager, modulesPath, inputs, ... }:

{

  # ISO image settings
  image.fileName = "nixos-usb-stick-tobi.iso";
  isoImage.squashfsCompression = "zstd";

  # Include the dotnix directory in the ISO
  isoImage.contents = [
    {
      source = ./../..;
      target = "/dotnix";
    }
  ];

  # Basic system settings
  networking.hostName = "nixos-live";
  networking.networkmanager.enable = true;
  networking.wireless.enable = lib.mkForce false;
  time.timeZone = "America/New_York";

  # Boot configuration for maximum hardware compatibility
  boot.kernelParams = [
    "snd_hda_intel.probe_mask=1"
    "snd_hda_intel.power_save=0"
  ];

  boot.extraModprobeConfig = ''
    options snd_hda_intel model=auto
  '';

  boot.blacklistedKernelModules = [ "snd_pcsp" ];


  # Enable dotnix desktop features
  dotnix.desktop.enable = true;

  # Required for Wayland and portals
  security.rtkit.enable = true;
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Essential packages for live environment
  environment.systemPackages = with pkgs; [
    git
    alacritty
    fuzzel
    chromium
    grim
    slurp
    wl-clipboard
    gparted
    file-roller
    htop
    neofetch
    pavucontrol
  ];

  programs.zsh.enable = true;

  # Enable sound with Pipewire
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    nerd-fonts.fira-code
  ];

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

  hardware.enableAllFirmware = true;

  # Set the NixOS release version
  system.stateVersion = "25.11";
}

