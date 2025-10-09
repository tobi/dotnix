{ config, lib, pkgs, ... }:

{
  # Sudo configuration
  # Don't show the sudo lecture at all (no "read this before using sudo" message)
  # Set sudo password prompt timeout to 0 (require password every time)
  security.sudo.extraConfig = ''
    Defaults lecture=never
    Defaults passwd_timeout=30
  '';

  # 1Password polkit integration
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "tobi" ];
  };

  # Enable fingerprint authentication
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;

  # Configure PAM services for fingerprint auth
  # Strategy: Both fingerprint and password available - whichever succeeds first
  security.pam.services = {
    # Sudo: fingerprint or password
    sudo.fprintAuth = true;

    # Polkit: fingerprint or password
    polkit-1.fprintAuth = true;

    # Login: password only (no fingerprint at initial login)
    login.fprintAuth = false;

    # GDM: password only at login screen
    gdm.fprintAuth = lib.mkDefault false;
    gdm-password.fprintAuth = lib.mkDefault false;

    # SDDM: password only at login screen
    sddm.fprintAuth = lib.mkDefault false;
    sddm-autologin.fprintAuth = lib.mkDefault false;

    # Screen lockers: fingerprint or password
    swaylock.fprintAuth = lib.mkIf (config.programs.swaylock.enable or false) true;
    gtklock.fprintAuth = lib.mkIf (config.programs.gtklock.enable or false) true;
  };
}
