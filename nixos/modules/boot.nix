{ config, pkgs, ... }:

{
    # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.extraFiles = {
    "EFI/Microsoft/Boot/bootmgfw.efi" = "/boot/windows-efi/EFI/Microsoft/Boot/bootmgfw.efi";
  };
  boot.loader.systemd-boot.configurationLimit = 5; # Keeps your boot menu clean
  boot.loader.timeout = 5; # Gives you 5 seconds to choose between NixOS and Windows

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;


  # Early initrd ACPI table override for hardware button sleep wake-up fix

  boot.initrd.prepend = [
    "${pkgs.runCommand "acpi-override" { nativeBuildInputs = [ pkgs.cpio ]; } ''
      mkdir -p kernel/firmware/acpi
      cp ${./facp.aml} kernel/firmware/acpi/facp.aml
      find kernel | cpio -H newc --create > $out
    ''}"
  ];

  # File System Mounts for Windows Interoperability

  fileSystems."/mnt/Windows" = {
    device = "/dev/disk/by-uuid/1C7259027258E1D6";
    fsType = "ntfs-3g";
    options = [ "rw" "uid=1000" "gid=100" "dmask=007" "fmask=117" "nofail" ];
  };

  fileSystems."/boot/windows-efi" = {
    device = "/dev/disk/by-uuid/1657-6A83";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" "allow_utime=0" ];
  };

  # Enable required kernel modules for Waydroid
  boot.kernelModules = [ "binder_linux" ];

  # Ensure the binder filesystems are mounted correctly on boot
  boot.specialFileSystems."/dev/binderfs" = {
    device = "binder";
    fsType = "binder";
  };
}
