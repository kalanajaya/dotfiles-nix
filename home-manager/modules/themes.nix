{ pkgs, ... }:

{
  # theme engine packages
  home.packages = with pkgs; [
    glib                # For gsettings manipulations
    gsettings-desktop-schemas
    lxappearance        # Optional: graphical tool to quickly preview themes
  ];

  # Configure GTK themes
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
    };
  };

  # Make cursor theme consistent across system components
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
  };

  # Force Qt applications to look like GTK apps
  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "adwaita-dark";
  };

}
