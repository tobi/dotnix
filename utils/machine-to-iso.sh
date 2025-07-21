#!/usr/bin/env bash

# Create a bootable USB stick with NixOS graphical installer that can install a specific machine configuration
# Usage: ./machine-to-iso.sh <machine-name>

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if a machine name was provided
if [ $# -eq 0 ]; then
    echo -e "${RED}Error: No machine name provided${NC}"
    echo "Usage: $0 <machine-name>"
    echo ""
    echo "Available machines:"
    ls -1 modules/machines/ | grep -v README 2>/dev/null || true
    exit 1
fi

MACHINE_NAME="$1"
FLAKE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MACHINE_DIR="${FLAKE_DIR}/modules/machines/${MACHINE_NAME}"

# Check if the machine configuration exists
if [ ! -d "${MACHINE_DIR}" ]; then
    echo -e "${RED}Error: Machine configuration '${MACHINE_NAME}' not found${NC}"
    echo "Available machines:"
    ls -1 "${FLAKE_DIR}/modules/machines/" | grep -v README 2>/dev/null || true
    exit 1
fi

echo -e "${BLUE}Building bootable ISO for machine: ${MACHINE_NAME}${NC}"
echo -e "${BLUE}Flake directory: ${FLAKE_DIR}${NC}"

# Create a custom ISO configuration
ISO_NAME="iso-${MACHINE_NAME}"
ISO_DIR="${FLAKE_DIR}/modules/machines/${ISO_NAME}"

# Clean up any previous ISO configuration
if [ -d "${ISO_DIR}" ]; then
    echo "Removing previous ISO configuration..."
    rm -rf "${ISO_DIR}"
fi

mkdir -p "${ISO_DIR}"

# Create the ISO configuration
cat > "${ISO_DIR}/configuration.nix" <<'EOF'
{ config, pkgs, lib, modulesPath, inputs, home-manager, ... }:

{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-graphical-gnome.nix")
    ../../nixos/dot.nix
    ../../nixos/user.nix
    ../../nixos/theme.nix
  ];

  # ISO image settings
  isoImage.isoName = "nixos-installer-MACHINE_NAME.iso";
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
    (pkgs.writeShellScriptBin "install-MACHINE_NAME" ''
      set -euo pipefail
      
      RED='\033[0;31m'
      GREEN='\033[0;32m'
      NC='\033[0m'
      
      echo "========================================="
      echo "NixOS Installation Script for MACHINE_NAME"
      echo "========================================="
      echo ""
      echo "This script will install the 'MACHINE_NAME' configuration"
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
      if [ -f "/mnt/etc/nixos/modules/machines/MACHINE_NAME/hardware-configuration.nix" ]; then
        cp "/mnt/etc/nixos/modules/machines/MACHINE_NAME/hardware-configuration.nix" \
           "/mnt/etc/nixos/modules/machines/MACHINE_NAME/hardware-configuration.nix.bak"
      fi
      
      # Copy the newly generated hardware config to the machine directory
      cp /mnt/etc/nixos/hardware-configuration.nix \
         "/mnt/etc/nixos/modules/machines/MACHINE_NAME/hardware-configuration.nix"
      
      # Install the system
      echo "Installing NixOS with MACHINE_NAME configuration..."
      nixos-install --flake "/mnt/etc/nixos#MACHINE_NAME" --no-root-password
      
      echo ""
      echo -e "''${GREEN}Installation complete!''${NC}"
      echo ""
      echo "Next steps:"
      echo "1. Remove the installation media"
      echo "2. Reboot the system"
      echo "3. The system will boot with the MACHINE_NAME configuration"
      echo ""
      echo "Note: Remember to set the root password after first boot!"
    '')
    (pkgs.writeShellScriptBin "switch-to-MACHINE_NAME" ''
      # Alternative command for advanced users who want to switch without full install
      echo "Switching to MACHINE_NAME configuration..."
      echo "This assumes you have already installed NixOS and just want to switch configurations."
      
      if [ ! -d "/etc/nixos" ]; then
        echo "Copying flake to /etc/nixos..."
        sudo cp -r /etc/nixos /etc/nixos
      fi
      
      sudo nixos-rebuild switch --flake "/etc/nixos#MACHINE_NAME"
    '')
  ];

  # Instructions on boot
  services.getty.helpLine = lib.mkForce ''
    
    Welcome to the NixOS installer for machine: MACHINE_NAME
    
    To install this configuration:
    1. Partition and mount your disks (use 'gparted' for GUI)
    2. Mount root to /mnt and boot to /mnt/boot
    3. Run: install-MACHINE_NAME
    
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
EOF

# Replace MACHINE_NAME placeholder with actual machine name
sed -i "s/MACHINE_NAME/${MACHINE_NAME}/g" "${ISO_DIR}/configuration.nix"

# Create default.nix for the ISO configuration
cat > "${ISO_DIR}/default.nix" <<EOF
{ inputs, ... }:
{
  imports = [
    ./configuration.nix
  ];
}
EOF

# Build the ISO
echo -e "${YELLOW}Building ISO image...${NC}"
echo "This may take a while..."

cd "${FLAKE_DIR}"
nix build ".#nixosConfigurations.${ISO_NAME}.config.system.build.isoImage" --show-trace

if [ $? -eq 0 ]; then
    # Find the ISO file
    ISO_PATH=$(find result/iso -name "*.iso" | head -n1)
    
    if [ -n "${ISO_PATH}" ]; then
        # Copy ISO to /tmp
        OUTPUT_ISO="/tmp/nixos-installer-${MACHINE_NAME}.iso"
        cp "${ISO_PATH}" "${OUTPUT_ISO}"
        
        echo ""
        echo -e "${GREEN}ISO build successful!${NC}"
        echo -e "${GREEN}ISO location: ${OUTPUT_ISO}${NC}"
        echo ""
        
        # Detect USB devices
        echo "Detecting USB devices..."
        USB_DEVICES=$(lsblk -d -o NAME,SIZE,TRAN,MODEL 2>/dev/null | grep -E "usb" | grep -v "loop" | awk '{print $1}' | head -n1)
        
        if [ -n "${USB_DEVICES}" ]; then
            USB_DEVICE="/dev/${USB_DEVICES}"
            USB_INFO=$(lsblk -d -o NAME,SIZE,MODEL 2>/dev/null | grep "^${USB_DEVICES}" | awk '{$1=""; print $0}' | xargs)
            echo -e "${YELLOW}Detected USB device: ${USB_DEVICE} (${USB_INFO})${NC}"
            echo ""
            echo "To write to this USB stick, run:"
            echo -e "${BLUE}  sudo dd if=${OUTPUT_ISO} of=${USB_DEVICE} bs=4M status=progress oflag=sync${NC}"
        else
            echo "No USB devices detected. To write to USB stick when available:"
            echo -e "${BLUE}  sudo dd if=${OUTPUT_ISO} of=/dev/sdX bs=4M status=progress oflag=sync${NC}"
        fi
        
        echo ""
        echo "Or use a GUI tool like Balena Etcher"
        echo ""
        echo -e "${YELLOW}WARNING: The dd command will ERASE ALL DATA on the target device!${NC}"
        echo "Make sure you have the correct device before running the command."
        
        # Clean up the temporary ISO configuration
        echo "Cleaning up ISO configuration..."
        rm -rf "${ISO_DIR}"
    else
        echo -e "${RED}Error: ISO file not found in result${NC}"
        rm -rf "${ISO_DIR}"
        exit 1
    fi
else
    echo -e "${RED}Error: ISO build failed${NC}"
    rm -rf "${ISO_DIR}"
    exit 1
fi