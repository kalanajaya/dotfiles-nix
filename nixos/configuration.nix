{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./modules/garbage.nix   # garbage collection and optimizations
      ./modules/network.nix
      ./modules/share.nix
      ./modules/apps.nix
      ./modules/boot.nix
      ./modules/nvidia.nix
      ./modules/de.nix
      ./modules/fonts.nix
      ./modules/power.nix
      #<home-manager/nixos>
    ];

  # Enable experimental features globally
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Enable KWallet PAM unlocking on login
  security.pam.services.login.kwallet.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Colombo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

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
    extraGroups = [ "networkmanager" "wheel" "docker" "adbusers" "input" "libvirtd" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
    shell = pkgs.zsh; # Sets Zsh as default system shell
  };

  programs.zsh.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  
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

  services.supergfxd.enable = true;

  # Provision state paths so systemd namespaces can instantiate cleanly
  systemd.tmpfiles.rules = [
    "d /etc/asusd 0755 root root -"
    "d /var/lib/asusd 0755 root root -"
  ];

  system.stateVersion = "26.05";

}
