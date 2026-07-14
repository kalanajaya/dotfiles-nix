{
  config,
  pkgs,
  ...
}: {
  # Dependencies for quickshell configuration toothpick
  environment.systemPackages = [
    pkgs.bluez
    pkgs.dbus
  ];
}
