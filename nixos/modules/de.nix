{ pkgs, ... }:

{
  ################################################################################
  #######################    KDE     #############################################
  ################################################################################

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  ################################################################################
  #######################    Hyprland     ########################################
  ################################################################################

  # Enable Hyprland Core Backend (Automagically adds xdg-desktop-portal-hyprland)
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    waybar 
    kitty # required for the default Hyprland config
  ];

  # Optional, hint Electron apps to use Wayland:
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  }
