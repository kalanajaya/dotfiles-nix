{ config, pkgs, ... }: 

{
  home.packages = with pkgs; [
    cliphist
    fuzzel
    wl-clipboard
    awww
    mpd-mpris
    rofi
    hyprshot
    grim
    slurp
    # Media and Hardware Control Utilities
    wireplumber      # Provides 'wpctl' for audio control
    brightnessctl    # Controls screen brightness levels
    playerctl        # Controls MPRIS media players (like MPD, Spotify)
    pavucontrol

    # Optical Character Recognition (OCR)
    tesseract
    
    # Dependencies for custom scripts
    xdg-utils # provides xdg-open

  ];

  programs.waybar = {
  enable = true;
  systemd = {
    enable = true;
    targets = [ "hyprland-session.target" ];
  };
};

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

  ##########################################
#          hypridle
##########################################

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";       # avoid starting multiple hyprlock instances
        before_sleep_cmd = "loginctl lock-session";    # lock before suspend
        after_sleep_cmd = "hyprctl dispatch dpms on";  # turn on display after wake
      };

      listener = [
      {
        timeout = 150;                                # 2.5 min
        on-timeout = "brightnessctl set 10%-";        # dim monitor backlight
        on-resume = "brightnessctl set +10%";         # restore monitor backlight
      }
      {
        timeout = 300;                                # 5 min
        on-timeout = "loginctl lock-session";         # lock screen using systemd locker
      }
      {
        timeout = 330;                                # 5.5 min
        on-timeout = "hyprctl dispatch dpms off";     # turn off screen
        on-resume = "hyprctl dispatch dpms on";       # turn on screen
      }
      {
        timeout = 600;                                # 10 min
        on-timeout = "systemctl suspend-then-hibernate";             # suspend system
      }
    ];
  };
  };
}


