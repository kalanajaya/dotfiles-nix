{ config, pkgs, ... }:

{
    # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  programs.nm-applet.enable = true;

  # Enable the hardware Bluetooth driver daemon  
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true; # Automatically power up the controller on boot

  # Enable the Blueman applet mechanism
  services.blueman.enable = true;

}

