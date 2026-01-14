# Frame Wallet (open-source Ethereum wallet) - AppImage package
# Repo: https://github.com/floating/frame
#
# NOTE: Update the sha256 hash after first build attempt.
# Nix will tell you the correct hash in the error message.
#
# To prefetch manually:
#   nix-prefetch-url --type sha256 "https://github.com/floating/frame/releases/download/v0.6.11/Frame-0.6.11.AppImage"
#
{ pkgs }:

pkgs.appimageTools.wrapType2 rec {
  pname = "frame-wallet";
  version = "0.6.11";

  src = pkgs.fetchurl {
    url = "https://github.com/floating/frame/releases/download/v${version}/Frame-${version}.AppImage";
    # UPDATE THIS HASH after the first build
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    name = "Frame-${version}.AppImage";
  };

  extraPkgs = pkgs: with pkgs; [
    # Electron-ish runtime deps that AppImages commonly need
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
    mesa
    nspr
    nss
    pango
    xdg-utils
    libGL
    libglvnd
  ];

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    cat > $out/share/applications/frame-wallet.desktop << EOF
    [Desktop Entry]
    Name=Frame Wallet
    Comment=Open-source Ethereum wallet (desktop)
    Exec=frame-wallet %F
    Terminal=false
    Type=Application
    Categories=Finance;Network;
    StartupNotify=true
    StartupWMClass=Frame
    EOF
  '';

  meta = with pkgs.lib; {
    description = "Frame - open-source Ethereum wallet for desktop";
    homepage = "https://frame.sh";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "frame-wallet";
  };
}

