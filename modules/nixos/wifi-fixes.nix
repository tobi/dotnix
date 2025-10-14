{ config, lib, pkgs, ... }:

{
  # WiFi stability fixes for MT7925 on Framework AMD
  networking.networkmanager.wifi = {
    # Disable WiFi power saving to fix handshake timeouts
    powersave = false;

    # Reduce aggressive roaming between mesh APs
    scanRandMacAddress = false;
  };

  # Disable ASPM for MT7925 WiFi card to prevent PCIe power issues
  boot.extraModprobeConfig = ''
    # Disable power management features that can cause WiFi instability
    options mt7925e disable_aspm=Y
  '';

  # Add WiFi debugging package
  environment.systemPackages = with pkgs; [
    wirelesstools # for iwconfig
    iw # for modern WiFi debugging
  ];
}
