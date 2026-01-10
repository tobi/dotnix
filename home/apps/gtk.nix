{ pkgs, config, ... }:
let
  theme = config.dotnix.theme;
in
{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-${theme.variant}";
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = theme.systemFont;
      size = 11;
    };
  };

  # gtk = {
  #   enable = true;
  #   font = {
  #     name = theme.systemFont;
  #     size = 10;
  #   };
  #   theme = {
  #     name = "Colloid-${if theme.variant == "dark" then "Dark" else "Light"}";
  #     package = pkgs.colloid-gtk-theme;
  #   };
  #   gtk3.extraConfig = {
  #     gtk-application-prefer-dark-theme = theme.variant == "dark";
  #   };
  #   gtk4.extraConfig = {
  #     gtk-application-prefer-dark-theme = theme.variant == "dark";
  #   };
  # };
}
