{ config, pkgs, ... }:

{
  # Ensure the necessary CLI tools are installed globally
  environment.systemPackages = with pkgs; [
    brightnessctl
    power-profiles-daemon
  ];

  # Create a udev rule that triggers when the AC power status changes
  services.udev.extraRules = ''
    SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${pkgs.writeShellScript "power-battery" ''
      export PATH=${pkgs.coreutils}/bin:${pkgs.gnugrep}/bin:${pkgs.gawk}/bin:${pkgs.sudo}/bin:${pkgs.findutils}/bin:$PATH
      
      # 1. Hardware/System Toggles
      ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set power-saver || true
      ${pkgs.brightnessctl}/bin/brightnessctl set 50% || true

      # 2. Extract active user and target their active Hyprland socket directly
      HYPR_USER=$(ls -l /run/user/*/wayland-1 2>/dev/null | awk '{print $3}' | head -n1)
      
      if [ -n "$HYPR_USER" ]; then
        HYPR_UID=$(id -u $HYPR_USER)
        # Find the socket inside the user's runtime directory instead of /tmp
        INSTANCE_SIG=$(ls -t /run/user/$HYPR_UID/hypr/ 2>/dev/null | head -n1)
        
        export XDG_RUNTIME_DIR=/run/user/$HYPR_UID
        export HYPRLAND_INSTANCE_SIGNATURE=$INSTANCE_SIG
        
        sudo -u $HYPR_USER -E ${pkgs.hyprland}/bin/hyprctl eval 'hl.monitor({ output = "eDP-1", mode = "1920x1080@60", position = "0x0", scale = 1 })' 2>&1 | logger -t hyprctl-udev
      fi
    ''}"

    SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${pkgs.writeShellScript "power-ac" ''
      export PATH=${pkgs.coreutils}/bin:${pkgs.gnugrep}/bin:${pkgs.gawk}/bin:${pkgs.sudo}/bin:${pkgs.findutils}/bin:$PATH

      ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set balanced || true
      ${pkgs.brightnessctl}/bin/brightnessctl set 90% || true

      HYPR_USER=$(ls -l /run/user/*/wayland-1 2>/dev/null | awk '{print $3}' | head -n1)
      
      if [ -n "$HYPR_USER" ]; then
        HYPR_UID=$(id -u $HYPR_USER)
        INSTANCE_SIG=$(ls -t /run/user/$HYPR_UID/hypr/ 2>/dev/null | head -n1)
        
        export XDG_RUNTIME_DIR=/run/user/$HYPR_UID
        export HYPRLAND_INSTANCE_SIGNATURE=$INSTANCE_SIG
        
        sudo -u $HYPR_USER -E ${pkgs.hyprland}/bin/hyprctl eval 'hl.monitor({ output = "eDP-1", mode = "1920x1080@144", position = "0x0", scale = 1 })' 2>&1 | logger -t hyprctl-udev
      fi
    ''}"

    # Grant read permissions for battery statistics to the video/input groups
    SUBSYSTEM=="power_supply", KERNEL=="BAT0", RUN+="${pkgs.coreutils}/bin/chmod -R a+r /sys/class/power_supply/BAT0/"
  '';

  ################################################
  #     SLEEP
  ################################################

  systemd.sleep.settings = {
    Sleep = {
      HibernateDelaySec = "300";
    };
  };

  boot.resumeDevice = "/dev/nvme0n1p8";
}
