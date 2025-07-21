{ config, pkgs, lib, modulesPath, inputs, home-manager, ... }:

{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-graphical-gnome.nix")
    ../../nixos/dot.nix
    ../../nixos/user.nix
    ../../nixos/theme.nix
  ];

  # ISO image settings
  isoImage.isoName = "nixos-installer-beetralisk.iso";
  isoImage.squashfsCompression = "zstd";
  isoImage.makeEfiBootable = true;
  isoImage.makeUsbBootable = true;

  # Include the entire flake in the ISO
  isoImage.contents = [
    {
      source = ../../../..;
      target = "/etc/nixos";
    }
  ];

  # Basic system settings
  networking.hostName = "nixos-installer";
  networking.networkmanager.enable = true;
  networking.wireless.enable = lib.mkForce false;
  time.timeZone = "America/New_York";

  # Enable the desktop environment
  dotnix.desktop.enable = true;

  # Boot configuration for maximum hardware compatibility
  boot.kernelParams = [
    "snd_hda_intel.probe_mask=1"
    "snd_hda_intel.power_save=0"
  ];

  boot.extraModprobeConfig = ''
    options snd_hda_intel model=auto
  '';

  boot.blacklistedKernelModules = [ "snd_pcsp" ];

  # Install script that will install the target machine
  environment.systemPackages = with pkgs; [
    git
    vim
    gparted
    htop
    neofetch
    (pkgs.writeShellScriptBin "install-beetralisk" ''
      set -euo pipefail
      
      RED='\033[0;31m'
      GREEN='\033[0;32m'
      NC='\033[0m'
      
      echo "========================================="
      echo "NixOS Installation Script for beetralisk"
      echo "========================================="
      echo ""
      echo "This script will install the 'beetralisk' configuration"
      echo "to /mnt and /mnt/boot"
      echo ""
      echo -e "''${RED}WARNING: This will install to the mounted disk!''${NC}"
      echo ""
      read -p "Are you sure you want to continue? (yes/no): " confirm
      
      if [ "$confirm" != "yes" ]; then
        echo "Installation cancelled."
        exit 1
      fi
      
      # Check if /mnt is mounted
      if ! mountpoint -q /mnt; then
        echo -e "''${RED}Error: /mnt is not mounted''${NC}"
        echo "Please mount your target filesystem to /mnt first"
        echo "Example:"
        echo "  mount /dev/sdXY /mnt"
        echo "  mkdir -p /mnt/boot"
        echo "  mount /dev/sdXZ /mnt/boot  # if using separate boot partition"
        exit 1
      fi
      
      # Copy the flake to the target system
      echo "Copying configuration to target system..."
      mkdir -p /mnt/etc
      cp -r /etc/nixos /mnt/etc/
      
      # Generate hardware configuration
      echo "Generating hardware configuration..."
      nixos-generate-config --root /mnt
      
      # Backup the generated hardware configuration
      if [ -f "/mnt/etc/nixos/modules/machines/beetralisk/hardware-configuration.nix" ]; then
        cp "/mnt/etc/nixos/modules/machines/beetralisk/hardware-configuration.nix" \
           "/mnt/etc/nixos/modules/machines/beetralisk/hardware-configuration.nix.bak"
      fi
      
      # Copy the newly generated hardware config to the machine directory
      cp /mnt/etc/nixos/hardware-configuration.nix \
         "/mnt/etc/nixos/modules/machines/beetralisk/hardware-configuration.nix"
      
      # Install the system
      echo "Installing NixOS with beetralisk configuration..."
      nixos-install --flake "/mnt/etc/nixos#beetralisk" --no-root-password
      
      echo ""
      echo -e "''${GREEN}Installation complete!''${NC}"
      echo ""
      echo "Next steps:"
      echo "1. Remove the installation media"
      echo "2. Reboot the system"
      echo "3. The system will boot with the beetralisk configuration"
      echo ""
      echo "Note: Remember to set the root password after first boot!"
    '')
    (pkgs.writeShellScriptBin "switch-to-beetralisk" ''
      # Alternative command for advanced users who want to switch without full install
      echo "Switching to beetralisk configuration..."
      echo "This assumes you have already installed NixOS and just want to switch configurations."
      
      if [ ! -d "/etc/nixos" ]; then
        echo "Copying flake to /etc/nixos..."
        sudo cp -r /etc/nixos /etc/nixos
      fi
      
      sudo nixos-rebuild switch --flake "/etc/nixos#beetralisk"
    '')
  ];

  # Instructions on boot
  services.getty.helpLine = lib.mkForce ''
    
    Welcome to the NixOS installer for machine: beetralisk
    
    To install this configuration:
    1. Partition and mount your disks (use 'gparted' for GUI)
    2. Mount root to /mnt and boot to /mnt/boot
    3. Run: install-beetralisk
    
    For help, see: https://nixos.org/manual/nixos/stable/#sec-installation
  '';

  # Enable firmware
  hardware.enableAllFirmware = true;

  # Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Set the NixOS release version
  system.stateVersion = "25.11";
}
