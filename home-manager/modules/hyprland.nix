{ config, pkgs, ... }: 

{

  xdg.configFile."hypr".source = ../dotfiles/hypr;
  xdg.configFile."hypr/scripts/random_wall.sh" = {
    source = ../dotfiles/hypr/scripts/random_wall.sh; # Path to the file in your dotfiles repo
    executable = true;                      # This forces the +x permission bit
  };
  xdg.configFile."waybar".source = ../dotfiles/waybar;


  #wayland.windowManager.hyprland.enable = true; # enable Hyprland

  # Optional, hint Electron apps to use Wayland:
  home.sessionVariables.NIXOS_OZONE_WL = "1";

#######################################################
########   SWAYNC 
#######################################################
  services.swaync = {
    enable = true;
    
    # Your JSON Settings
    settings = {
      "$schema" = "/etc/xdg/swaync/configSchema.json";
      positionX = "right";
      positionY = "top";
      layer = "top";
      control-center-margin-top = 10;
      control-center-margin-bottom = 10;
      control-center-margin-right = 10;
      control-center-margin-left = 10;
      
      notification-icon-size = 24;
      notification-body-image-height = 40;
      notification-body-image-width = 40;
      
      timeout = 5;
      timeout-low = 2;
      timeout-critical = 0;
      fit-to-screen = true;
      keyboard-shortcuts = true;
      image-visibility = "always";
      transition-time = 200;
      hide-on-clear = true;
      hide-on-touch = true;
    };

    # Your CSS Theme
    style = ''
      :root {
        --bg-color: rgba(30, 30, 46, 0.85);
        --border-color: rgba(255, 255, 255, 0.1);
        --text-color: #cdd6f4;
        --critical-color: #f38ba8;
      }

      * {
        font-family: "JetBrainsMono Nerd Font", Sans;
        font-size: 13px;
      }

      .notification-row {
        outline: none;
        background: transparent;
        padding: 0;
        margin: 0;
      }

      .notification {
        background: var(--bg-color);
        border: 1px solid var(--border-color);
        border-radius: 10px;
        color: var(--text-color);
        padding: 10px 14px;
        margin: 4px 0px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.4);
        min-width: 260px;
        max-width: 320px;
        transition: background 0.15s ease-in-out;
      }

      .notification-content {
        margin: 0;
        padding: 0;
      }

      .notification-text {
        margin: 0;
        padding: 0;
      }

      .notification-title {
        font-weight: bold;
        font-size: 13px;
        margin-bottom: 2px;
      }

      .notification-body {
        font-size: 12px;
        opacity: 0.9;
      }

      .notification-row .notification:hover,
      .notification-row .notification:focus {
        background: rgba(45, 45, 68, 0.9) !important;
        border-color: rgba(255, 255, 255, 0.2) !important;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.5) !important;
      }

      .notification-default-image,
      .notification-image {
        margin-right: 12px;
        background: transparent;
      }

      .critical {
        border-color: rgba(243, 139, 168, 0.4);
      }
    '';  
  };
}
