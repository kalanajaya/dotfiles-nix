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

  # Enable appimage support
  programs.appimage.enable = true;


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    # --- SYSTEM & HARDWARE UTILITIES ---
    asusctl                  # Command-line tool for ASUS features
    wl-clipboard             # Required for Waydroid clipboard sharing
    fastfetch
    hyprlauncher
    wineWow64Packages.stable
    kdePackages.ark  # The core graphical archiving tool
    unrar            # Unfree utility to unpack .rar files natively

    # --- GAMING TOOLS ---
    lutris                   # Open-source gaming platform
    protonup-qt              # Graphical UI to easily download Proton-GE / Wine-GE layers for Steam & Lutris
    mangohud                 # Vulkan/OpenGL performance overlay for monitoring FPS & temperatures
    vulkan-tools             # Helpful for verification (includes vkcube)
    goverlay

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
    neovim                   # Your primary IDE/Text Editor
    
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
    nvd # to see report about nix build process
    
    #btop
    (btop.override { cudaSupport = true; }) # with gpu support

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

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

# --- VIRTUALIZATION & CONTAINERS ---

  virtualisation.waydroid.enable = true;
  # Newer kernel versions may need
  virtualisation.waydroid.package = pkgs.waydroid-nftables;

  networking.firewall.trustedInterfaces = [ "waydroid0" ];


  # Enable Docker Daemon
  virtualisation.docker.enable = true;

  # --- LOCAL SEARXNG INSTANCE ---

  # 1. Automate the generation and hardening of the secret file
  system.activationScripts.searxng-secret = {
    text = ''
      if [ ! -f /var/lib/secrets/searxng.env ]; then
        ${pkgs.coreutils}/bin/mkdir -p /var/lib/secrets
        echo "SEARXNG_SECRET_KEY=$(${pkgs.openssl}/bin/openssl rand -hex 32)" > /var/lib/secrets/searxng.env
        ${pkgs.coreutils}/bin/chmod 600 /var/lib/secrets/searxng.env
      fi
    '';
  };
  services.searx = {
    enable = true;
    environmentFile = "/var/lib/secrets/searxng.env";
    package = pkgs.searxng;
    settings = {
      server = {
        port = 8888;
        bind_address = "127.0.0.1";
        secret_key = "@SEARXNG_SECRET_KEY@";
      };
      ui = {
        theme = "oscar";
      };
    };
  };

  # Enable Virt-Manager / libvirtd daemon
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false; # Runs QEMU as an unprivileged user for security
      swtpm.enable = true; # Required for Windows 11 TPM emulation
    };
  };

  # Install Virt-Manager GUI tool if you want a visual interface
  programs.virt-manager.enable = true;

  # automatically detect and go into nix shells
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

}
