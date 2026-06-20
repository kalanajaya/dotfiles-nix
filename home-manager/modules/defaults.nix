{ pkgs, ... }: {

  # Define default application associations
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Web Browsing & Links (LibreWolf)
      "text/html" = [ "librewolf.desktop" ];
      "x-scheme-handler/http" = [ "librewolf.desktop" ];
      "x-scheme-handler/https" = [ "librewolf.desktop" ];
      "x-scheme-handler/about" = [ "librewolf.desktop" ];
      "x-scheme-handler/unknown" = [ "librewolf.desktop" ];

      # Document Viewer (Okular)
      "application/pdf" = [ "okular.desktop" ];

      # Video Playback (VLC)
      "video/mp4" = [ "vlc.desktop" ];
      "video/mpeg" = [ "vlc.desktop" ];
      "video/quicktime" = [ "vlc.desktop" ];
      "video/x-matroska" = [ "vlc.desktop" ]; # .mkv files
      "video/x-msvideo" = [ "vlc.desktop" ];  # .avi files
      "video/x-flv" = [ "vlc.desktop" ];

      # Windows Executables (Wine)
      "application/x-ms-dos-executable" = [ "wine.desktop" ];
      "application/x-msi" = [ "wine.desktop" ];

      # Directory Handling (Ensures Dolphin opens folders natively)
      "inode/directory" = [ "org.kde.dolphin.desktop" ];   

      # Set Ark as the default handler for compressed archives
      "application/vnd.rar" = [ "org.kde.ark.desktop" ];
      "application/x-rar" = [ "org.kde.ark.desktop" ];
      "application/x-rar-compressed" = [ "org.kde.ark.desktop" ];
      "application/zip" = [ "org.kde.ark.desktop" ];
      "application/x-tar" = [ "org.kde.ark.desktop" ];
      "application/x-7z-compressed" = [ "org.kde.ark.desktop" ];

      };

  };
}
