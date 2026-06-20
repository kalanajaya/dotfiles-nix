{ pkgs, ... }:

{
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Nix can find identical files across completely different packages 
  # (like duplicated libraries or icons) and hard-link them together, 
  # saving massive amounts of redundant disk space.
  nix.settings.auto-optimise-store = true;
}
