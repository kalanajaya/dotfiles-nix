# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./modules/network.nix
      ./modules/share.nix
      ./modules/apps.nix
      ./modules/boot.nix
      <home-manager/nixos>
    ];



  
  # Enable KWallet PAM unlocking on login
  security.pam.services.login.kwallet.enable = true;


  # Set your time zone.
  time.timeZone = "Asia/Colombo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."ravenousbyte" = {
    isNormalUser = true;
    description = "Kalana Jayawardena";
    extraGroups = [ "networkmanager" "wheel" "docker" "adbusers" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
    shell = pkgs.zsh; # Sets Zsh as default system shell
  };

  programs.zsh.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  # Enable Hyprland Core Backend
  programs.hyprland.enable = true;


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:


  # --- HARDWARE & ASUS LAPTOP CONTROL ---
  # Enables asusctl and rog-control-center for your ASUS TUF F15
  services.asusd = {
    enable = true;
  };

  # Provision state paths so systemd namespaces can instantiate cleanly
  systemd.tmpfiles.rules = [
    "d /etc/asusd 0755 root root -"
    "d /var/lib/asusd 0755 root root -"
  ];



  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?


  fonts.packages = with pkgs; [
    # Install specific nerd fonts (NixOS 25.05+ syntax)
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    
    # Optional: Font Awesome icons if your waybar config explicitly relies on them
    font-awesome
  ];

# Enable global XDG menu generation (Fixes application menu missing errors)
  xdg.menus.enable = true;

  xdg.portal = {
  enable = true;
  extraPortals = [ 
      pkgs.xdg-desktop-portal-hyprland # Handles screenshots, screen sharing, and windows
      pkgs.kdePackages.xdg-desktop-portal-kde # Crucial for Dolphin and Qt apps
      pkgs.xdg-desktop-portal-gtk      # Handles file choosers and app configurations
    ];
  config.common.default = "*";
};
# 3. Enable DConf (Required for many GUI apps to save their settings)
  programs.dconf.enable = true;

  # 4. Essential System Services
  security.polkit.enable = true; # Allows GUI apps to ask for sudo passwords
  services.gvfs.enable = true;   # Required for Dolphin to mount USBs and trash bins
  services.udisks2.enable = true;

# 2. Install shared-mime-info so the system can read file signatures (.mp4, .rar, etc)
  environment.systemPackages = with pkgs; [
    shared-mime-info
    xdg-utils # Provides CLI tools like xdg-mime and xdg-open
     
];

  # Natively generate a universal application menu structure directly into /etc/xdg/menus/
  environment.etc."xdg/menus/applications.menu".text = ''
    <!DOCTYPE Menu PUBLIC "-//freedesktop//DTD Menu 1.0//EN"
      "http://www.freedesktop.org/standards/menu-spec/menu-1.0.dtd">
    <Menu>
      <Name>Applications</Name>
      <MergeFile type="parent">/etc/xdg/menus/applications.menu</MergeFile>
      <Include>
        <All/>
      </Include>
    </Menu>
  '';
}
