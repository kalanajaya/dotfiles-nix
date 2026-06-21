{ config, pkgs, ... }:

{
  # Allow unfree packages and explicitly sign off on the standard Google Android SDK licenses
  nixpkgs.config = {
    allowUnfree = true;
    android_sdk.accept_license = true;

    permittedInsecurePackages = [
                "librewolf-bin-151.0.1-2"
                "librewolf-bin-unwrapped-151.0.1-2"
              ];
    
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    # --- SYSTEM & HARDWARE UTILITIES ---
    asusctl                  # Command-line tool for ASUS features
    wl-clipboard             # Required for Waydroid clipboard sharing
    fastfetch
    hyprlauncher
    waybar
    wineWow64Packages.stable
    kdePackages.ark  # The core graphical archiving tool
    unrar            # Unfree utility to unpack .rar files natively

    # --- GAMING TOOLS ---
    lutris                   # Open-source gaming platform
    protonup-qt              # Graphical UI to easily download Proton-GE / Wine-GE layers for Steam & Lutris
    mangohud                 # Vulkan/OpenGL performance overlay for monitoring FPS & temperatures
    vulkan-tools             # Helpful for verification (includes vkcube)

    # --- MOBILE & WEB DEVELOPMENT ---
    flutter                  # Flutter SDK for app development
    firebase-tools           # Firebase CLI tool
    jdk17                    # Frequently required for Flutter android builds
    android-tools            # Provides adb, fastboot, etc.
    gcc
    clang-tools              # Installs stable clang-format, clangd, etc.
    tree-sitter
    stylua
    markdownlint-cli
    gh
    alejandra
    nixd

    # Language Servers (Installed natively)
    # --- Python ---
    pyright
    black

    # --- Java ---
    jdt-language-server
    vscode-extensions.vscjava.vscode-java-debug
    vscode-extensions.vscjava.vscode-java-test  

    llvmPackages.clang-tools # Provides clangd for C++
    vscode-langservers-extracted # Contains both css-lsp and html-lsp
    emmet-ls             # For HTML/CSS emmet support

    # --- TERMINAL, NOTES & BROWSERS ---
    alacritty
    discord
    neovim                   # Your primary IDE/Text Editor
    obsidian                 # Markdown knowledge base application
    librewolf-bin               # Privacy-focused browser fork of Firefox

    # --- MULTIMEDIA ---
    vlc                      # Media player
    rmpc                     # Rich Music Player Client (MPD client)
    mpd                      # Music Player Daemon (if you don't already have it enabled as a service)

    # --- GENERAL TOOLS ---
    git
    wget
    curl
    unzip
    nodejs
    gnumake

  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];

  # --- GAMING INFRASTRUCTURE ---
  # Steam requires specific 32-bit graphics libraries and firewall settings, so it needs a dedicated toggle
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

# --- VIRTUALIZATION & CONTAINERS ---

  virtualisation.waydroid.enable = true;
  # Newer kernel versions may need
  virtualisation.waydroid.package = pkgs.waydroid-nftables;

  networking.firewall.trustedInterfaces = [ "waydroid0" ];


  # Enable Docker Daemon
  virtualisation.docker.enable = true;

  # --- LOCAL SEARXNG INSTANCE ---
  services.searx = {
    enable = true;
    package = pkgs.searxng;
    settings = {
      server = {
        port = 8888;
        bind_address = "127.0.0.1";
        secret_key = "change-this-to-a-long-random-string-for-security";
      };
      ui = {
        theme = "oscar";
      };
    };
  };
}
