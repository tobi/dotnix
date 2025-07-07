{ config, lib, pkgs, theme, ... }:
{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-${theme.variant}";
    };
  };

  gtk = {
    enable = true;
    font = {
      name = "Inter";
      size = 12;
    };
    theme = {
      name = "Adwaita-${theme.variant}";
      package = pkgs.gnome-themes-extra;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = theme.variant == "dark";
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = theme.variant == "dark";
    };
  };
}
