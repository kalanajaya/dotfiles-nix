{ config, pkgs, ... }:

{
  # ---------------------------------------------------------
  # Kitty Terminal Configuration
  # ---------------------------------------------------------
  home.packages = with pkgs; [
    kitty
  ];

  # ---------------------------------------------------------
  # Zsh Shell & Interactive Plugins
  # ---------------------------------------------------------
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # High-utility shell aliases
    shellAliases = {
      v = "nvim";
      ff = "fastfetch";
      nrs = "sudo nixos-rebuild switch --flake ~/dotfiles#nixos";
      hms = "home-manager switch --flake ~/dotfiles#yourusername";
      nixos = "nvim ~/dotfiles";
      nixup = "nix flake update --flake ~/dotfiles";
    };

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
  };

  # ---------------------------------------------------------
  # Modern Prompt Engine (Starship)
  # ---------------------------------------------------------
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    
    # Custom prompt layout settings
    settings = {
      add_newline = false;
      line_break.disabled = true;
      
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };
}
