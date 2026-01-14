# Redot Engine - Godot fork
# https://github.com/Redot-Engine/redot-engine
#
# NOTE: Update the sha256 hash after first build attempt.
# Nix will tell you the correct hash in the error message.
#
{ pkgs }:

let
  version = "4.3-stable";
in
pkgs.stdenv.mkDerivation {
  pname = "redot";
  inherit version;
  
  src = pkgs.fetchzip {
    url = "https://github.com/Redot-Engine/redot-engine/releases/download/${version}/Redot_v${version}_linux.x86_64.zip";
    # UPDATE THIS HASH - run the build once and Nix will give you the correct hash
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    stripRoot = false;
  };

  nativeBuildInputs = with pkgs; [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = with pkgs; [
    # Graphics
    vulkan-loader
    libGL
    libglvnd
    
    # X11
    xorg.libX11
    xorg.libXcursor
    xorg.libXinerama
    xorg.libXext
    xorg.libXrandr
    xorg.libXrender
    xorg.libXi
    xorg.libXfixes
    
    # Audio
    alsa-lib
    libpulseaudio
    
    # Other
    udev
    dbus
    fontconfig
    freetype
    libxkbcommon
    speechd
  ];

  installPhase = ''
    runHook preInstall
    
    mkdir -p $out/bin
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/hicolor/256x256/apps
    
    # Find and install the Redot binary
    find . -name "Redot*" -type f -executable -exec cp {} $out/bin/redot \;
    chmod +x $out/bin/redot
    
    # Create desktop entry
    cat > $out/share/applications/redot.desktop << EOF
    [Desktop Entry]
    Name=Redot Engine
    Comment=Multi-platform 2D and 3D game engine (Godot fork)
    Exec=redot %F
    Terminal=false
    Type=Application
    Icon=redot
    Categories=Development;IDE;Game;
    MimeType=application/x-godot-project;
    StartupNotify=true
    StartupWMClass=Redot
    EOF
    
    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "Redot Engine - A community-driven Godot fork";
    homepage = "https://github.com/Redot-Engine/redot-engine";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "redot";
  };
}
