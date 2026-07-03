{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    
    # This automatically injects the 'ya' wrapper into Zsh.
    # When you type 'y' in the terminal, it opens Yazi, and when you exit, 
    # your terminal will automatically 'cd' into the last directory you were viewing!
    enableZshIntegration = true; 

    # Equivalent to ~/.config/yazi/yazi.toml
    settings = {
      manager = {
        show_hidden = false;
        sort_by = "alphabetical";
        sort_dir_first = true;
        linemode = "size";
        show_symlink = true;
      };
      
      preview = {
        max_width = 1920;
        max_height = 1080;
        image_filter = "lanczos3"; # High-quality image scaling
        image_quality = 90;
      };
    };

    # Equivalent to ~/.config/yazi/keymap.toml
    keymap = {
      manager.prepend_keymap = [
        {
          on = [ "g" "h" ];
          run = "cd ~";
          desc = "Go to home directory";
        }
        {
          on = [ "g" "c" ];
          run = "cd ~/.config";
          desc = "Go to config directory";
        }
      ];
    };

    # Equivalent to ~/.config/yazi/theme.toml
    theme = {
      manager = {
        cwd = { fg = "blue"; bold = true; };
        hovered = { bg = "darkgray"; };
      };
    };
  };

  home.packages = with pkgs; [
    # Yazi preview dependencies
    ffmpegthumbnailer # Video thumbnails
    imagemagick       # Image manipulation and SVG previews
    poppler           # PDF previews (pdftoppm)
    p7zip             # Archive extraction and previews
    jq                # JSON previews
    ripgrep           # Fast file searching
    fd                # Fast directory searching
  ];
}
