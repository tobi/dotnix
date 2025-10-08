{ config, lib, pkgs, ... }:

{
  # Sudo configuration
  security.sudo.extraConfig = ''
    Defaults lecture=never
    Defaults passwd_timeout=0
  '';

  # Enable fingerprint authentication
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;

  # Configure PAM services for fingerprint auth
  # Strategy: Always offer password, with fingerprint as faster alternative
  security.pam.services = {
    # Sudo: try fingerprint first (10s timeout), then password
    sudo = {
      fprintAuth = true;
      rules.auth.fprintd = {
        order = config.security.pam.services.sudo.rules.auth.unix.order + 10;
        settings.timeout = 10;
      };
    };

    # Polkit: same as sudo
    polkit-1 = {
      fprintAuth = true;
      rules.auth.fprintd = {
        order = config.security.pam.services.polkit-1.rules.auth.unix.order + 10;
        settings.timeout = 10;
      };
    };

    # Login: password only (no fingerprint at initial login)
    login.fprintAuth = false;

    # GDM: password only at login screen
    gdm.fprintAuth = lib.mkDefault false;
    gdm-password.fprintAuth = lib.mkDefault false;

    # SDDM: password only at login screen
    sddm.fprintAuth = lib.mkDefault false;
    sddm-autologin.fprintAuth = lib.mkDefault false;

    # Screen lockers: fingerprint with password fallback
    swaylock = lib.mkIf (config.programs.swaylock.enable or false) {
      fprintAuth = true;
      rules.auth.fprintd = {
        order = config.security.pam.services.swaylock.rules.auth.unix.order + 10;
        settings.timeout = 10;
      };
    };

    gtklock = lib.mkIf (config.programs.gtklock.enable or false) {
      fprintAuth = true;
      rules.auth.fprintd = {
        order = config.security.pam.services.gtklock.rules.auth.unix.order + 10;
        settings.timeout = 10;
      };
    };
  };
}
