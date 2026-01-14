# Cursor IDE - AppImage package
# 
# NOTE: The sha256 hash needs to be updated after first build attempt.
# Nix will tell you the correct hash in the error message.
#
# To get the hash manually:
#   nix-prefetch-url --type sha256 "https://downloader.cursor.sh/linux/appImage/x64"
#
{ pkgs }:

pkgs.appimageTools.wrapType2 rec {
  pname = "cursor";
  version = "latest";
  
  src = pkgs.fetchurl {
    url = "https://downloader.cursor.sh/linux/appImage/x64";
    # UPDATE THIS HASH - run the build once and Nix will give you the correct hash
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    name = "cursor-${version}.AppImage";
  };

  extraPkgs = pkgs: with pkgs; [
    # Required dependencies
    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libxshmfence
    libxkbcommon
    alsa-lib
    at-spi2-atk
    at-spi2-core
    cairo
    cups
    dbus
    expat
    gdk-pixbuf
    glib
    gtk3
    libdrm
    libnotify
    libsecret
    libuuid
    mesa
    nspr
    nss
    pango
    systemd
    xdg-utils
    
    # For Electron
    libGL
    libglvnd
  ];

  extraInstallCommands = ''
    # Create desktop entry
    mkdir -p $out/share/applications
    cat > $out/share/applications/cursor.desktop << EOF
    [Desktop Entry]
    Name=Cursor
    Comment=AI-first Code Editor
    Exec=cursor %F
    Terminal=false
    Type=Application
    Icon=cursor
    Categories=Development;IDE;TextEditor;
    MimeType=text/plain;inode/directory;
    StartupNotify=true
    StartupWMClass=Cursor
    EOF
    
    # Extract and install icon
    ${pkgs.appimageTools.extractType2 { inherit pname version src; }}/cursor.png
    mkdir -p $out/share/icons/hicolor/256x256/apps
    cp ${pkgs.appimageTools.extractType2 { inherit pname version src; }}/cursor.png $out/share/icons/hicolor/256x256/apps/ || true
  '';

  meta = with pkgs.lib; {
    description = "Cursor - The AI-first Code Editor";
    homepage = "https://cursor.sh";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "cursor";
  };
}
