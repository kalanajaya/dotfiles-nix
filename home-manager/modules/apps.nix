{ pkgs, ... }:

{
  home.packages = with pkgs; [

     yazi
     obsidian                 # Markdown knowledge base application
     librewolf-bin               # Privacy-focused browser fork of Firefox
     onlyoffice-desktopeditors
     discord
     xournalpp


  ];
  
  services.syncthing = {
    enable = true;
  };

}
