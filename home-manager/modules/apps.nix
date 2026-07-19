{pkgs, ...}: {
  home.packages = with pkgs; [
    yazi
    obsidian # Markdown knowledge base application
    librewolf-bin # Privacy-focused browser fork of Firefox
    onlyoffice-desktopeditors
    discord
    xournalpp
    krita
    qbittorrent
  ];

  services.syncthing = {
    enable = true;
  };

  # automatically detect and go into nix shells
  programs.direnv = {
    enable = true;
    enableZshIntegration = true; # Set to true if you use Zsh
    enableBashIntegration = true; # Set to true if you use Bash
    nix-direnv.enable = true;
  };
}
