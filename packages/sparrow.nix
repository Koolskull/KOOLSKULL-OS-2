# Sparrow Wallet (open-source Bitcoin wallet) - packaged from official tarball
# Repo: https://github.com/sparrowwallet/sparrow
#
# NOTE: Update the sha256 hash after first build attempt.
# Nix will tell you the correct hash in the error message.
#
# Prefetch manually:
#   nix-prefetch-url --type sha256 "https://github.com/sparrowwallet/sparrow/releases/download/2.3.1/sparrowwallet-2.3.1-x86_64.tar.gz"
#
{ pkgs }:

let
  version = "2.3.1";
in
pkgs.stdenv.mkDerivation {
  pname = "sparrow-wallet";
  inherit version;

  src = pkgs.fetchzip {
    url = "https://github.com/sparrowwallet/sparrow/releases/download/${version}/sparrowwallet-${version}-x86_64.tar.gz";
    # UPDATE THIS HASH after the first build
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    stripRoot = false;
  };

  nativeBuildInputs = with pkgs; [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = with pkgs; [
    # GTK & common runtime deps
    gtk3
    glib
    cairo
    pango
    gdk-pixbuf
    atk
    at-spi2-atk
    at-spi2-core
    dbus
    alsa-lib
    libGL
    libglvnd
    xorg.libX11
    xorg.libXext
    xorg.libXrender
    xorg.libXi
    xorg.libXrandr
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXfixes
    xorg.libXcomposite
    xorg.libxcb
    libxkbcommon
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/sparrow
    cp -R ./* $out/opt/sparrow/

    mkdir -p $out/bin
    makeWrapper $out/opt/sparrow/bin/Sparrow $out/bin/sparrow

    mkdir -p $out/share/applications
    cat > $out/share/applications/sparrow.desktop << EOF
    [Desktop Entry]
    Name=Sparrow Wallet
    Comment=Open-source Bitcoin wallet focused on security and privacy
    Exec=sparrow %F
    Terminal=false
    Type=Application
    Categories=Finance;Network;
    StartupNotify=true
    StartupWMClass=Sparrow
    EOF

    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "Sparrow Wallet - open-source Bitcoin wallet";
    homepage = "https://github.com/sparrowwallet/sparrow";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    mainProgram = "sparrow";
  };
}

