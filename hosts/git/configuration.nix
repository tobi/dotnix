/*
  Git Server - LXC Container Specific Configuration

  This file contains only LXC-specific settings.
  Service configuration is handled via dotnix.services.* options.
*/

_:

{
  system.stateVersion = "25.11";

  boot.isContainer = true;

  # Allow user tobi to run sudo without password (for remote management)
  security.sudo.extraRules = [
    {
      users = [ "tobi" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
