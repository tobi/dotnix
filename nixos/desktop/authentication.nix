/*
  Authentication Configuration

  System-level authentication setup:
  - 1Password integration
  - Fingerprint authentication (fprintd)
  - PAM service configuration
  - Sudo configuration
*/

{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.dotnix.desktop.enable {
    # Sudo configuration
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
    services.fprintd = {
      enable = true;
      tod = {
        enable = true;
        driver = pkgs.libfprint-2-tod1-goodix;
      };
    };

    # Configure PAM services for fingerprint auth
    security.pam.services = {
      # Sudo: fingerprint or password
      sudo.fprintAuth = false;
      swaylock.fprintAuth = false;

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
      gtklock.fprintAuth = lib.mkIf (config.programs.gtklock.enable or false) true;
    };
  };
}
