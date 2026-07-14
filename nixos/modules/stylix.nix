{
  pkgs,
  lib,
  config,
  ...
}: {
  stylix.enable = true;
  stylix.autoEnable = true;

  # 1. Provide a mandatory image (Stylix will still use this for lockscreens/SDDM)
  stylix.image = ./Wall/1.jpg;

  # 2. Prevent Stylix from trying to set the wallpaper on your desktop
  # (This stops it from conflicting with swww)
  #stylix.targets.hyprpaper.enable = false;

  # Inject target overrides directly into Home Manager from here
  home-manager.sharedModules = [
    {
      stylix.targets.ghostty.enable = false;
      stylix.targets.btop.enable = false;
      stylix.targets.dunst.enable = false;
    }
  ];

  # Modern Dark Theme Palette (Pick your favorite below)
  # 1. Catppuccin Mocha (Rich, vibrant dark pastel)
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

  # 2. Tokyo Night Storm (Uncomment this if you prefer a deeper, cool-toned dark blue/grey)
  # stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-storm.yaml";

  # Sleek, matching dark cursor
  stylix.cursor = {
    package = pkgs.rose-pine-cursor;
    name = "BreezeX-RosePine-Linux"; # Swapped "Dawn" to "RosePine" to match a dark theme
    size = 20;
  };

  stylix.polarity = "dark";

  # Professional font configuration
  stylix.fonts = {
    sansSerif = {
      package = pkgs.inter;
      name = "Inter";
    };
    monospace = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font";
    };

    # Crisp font sizing for high-res modern layouts
    sizes = {
      applications = 10;
      desktop = 10;
      popups = 10;
      terminal = 11;
    };
  };
}
