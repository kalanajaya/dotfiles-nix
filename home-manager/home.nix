{ config, pkgs, ... }:

{
  imports = [
    ./modules/mpd.nix
    ./modules/terminal.nix
    ./modules/defaults.nix
    ./modules/hyprland.nix
    ./modules/themes.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "ravenousbyte";
  home.homeDirectory = "/home/ravenousbyte";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "26.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.wl-clipboard
    pkgs.awww
    pkgs.mpd-mpris

    # Media and Hardware Control Utilities
    pkgs.wireplumber      # Provides 'wpctl' for audio control
    pkgs.brightnessctl    # Controls screen brightness levels
    pkgs.playerctl        # Controls MPRIS media players (like MPD, Spotify)

    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    pkgs.stylua # Lua Formatter
    pkgs.nixd
    pkgs.alejandra
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/ravenousbyte/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This copies the files into the read-only Nix store whenever you switch
  xdg.configFile."nvim".source = ./dotfiles/nvim;
  xdg.configFile."kitty".source = ./dotfiles/kitty;

  # -------------------------------------------------------------
  # MPD to MPRIS Bridge Daemon (Corrected Option Paths)
  # -------------------------------------------------------------
  services.mpd-mpris = {
    enable = true;
    
    # We alter the package wrapper directly to parse your exact local path strings
    package = pkgs.symlinkJoin {
      name = "mpd-mpris-wrapped";
      paths = [ pkgs.mpd-mpris ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/mpd-mpris \
          --add-flags "--host ${config.home.homeDirectory}/.config/mpd/socket"
      '';
    };
  };
}
