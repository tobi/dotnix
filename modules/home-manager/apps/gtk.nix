{
  pkgs,
  theme,
  ...
}:
{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-${theme.variant}";
    };
  };

  gtk = {
    enable = true;
    font = {
      name = theme.systemFont;
      size = 10;
    };
    theme = {
      name = "Colloid-${if theme.variant == "dark" then "Dark" else "Light"}";
      package = pkgs.colloid-gtk-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = theme.variant == "dark";
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = theme.variant == "dark";
    };
  };
}
