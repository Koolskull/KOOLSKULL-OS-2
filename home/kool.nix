# Home Manager configuration for user 'kool'
{ config, pkgs, pkgs-unstable, ... }:

let
  # Import Cursor IDE package
  cursor = import ../packages/cursor.nix { inherit pkgs; };
  
  # Import Redot Engine package (Godot fork)
  redot = import ../packages/redot.nix { inherit pkgs; };
in
{
  home.username = "kool";
  home.homeDirectory = "/home/kool";

  # Packages installed to user profile
  home.packages = with pkgs; [
    # ═══════════════════════════════════════════════════════════
    # 🎨 CREATIVE SUITE
    # ═══════════════════════════════════════════════════════════
    
    # 3D & Graphics
    pkgs-unstable.blender    # Blender (latest from unstable for newest version)
    krita                    # Digital painting
    gimp                     # Image editor
    freecad                  # 3D CAD modeling
    
    # ═══════════════════════════════════════════════════════════
    # 🎵 MUSIC TRACKERS
    # ═══════════════════════════════════════════════════════════
    
    milkytracker             # Classic MOD tracker
    furnace                  # Multi-system chiptune tracker
    schismtracker            # Impulse Tracker-style music tracker (IT/XM/S3M/MOD)
    
    # OpenMPT via Wine (Windows-only tracker)
    wineWowPackages.stable   # Wine for running OpenMPT
    winetricks               # Helper for Wine
    
    # DAWs & Audio Production
    lmms                     # Music production (FL Studio-like)
    ardour                   # Professional DAW
    audacity                 # Audio editor
    
    # ═══════════════════════════════════════════════════════════
    # 💻 DEVELOPMENT
    # ═══════════════════════════════════════════════════════════
    
    # IDEs & Editors
    cursor                   # Cursor IDE (AI code editor)
    vscode                   # Visual Studio Code
    zed-editor               # Zed (fast modern editor)
    kate                     # KDE Advanced Text Editor
    
    # Game Development
    redot                    # Redot Engine (Godot fork)
    
    # JavaScript / Node.js
    nodejs_22                # Node.js LTS
    nodePackages.npm         # npm package manager
    bun                      # Bun runtime (fast JS/TS)
    
    # ═══════════════════════════════════════════════════════════
    # 🌐 BROWSER
    # ═══════════════════════════════════════════════════════════
    
    brave                    # Brave Browser (default)
    
    # ═══════════════════════════════════════════════════════════
    # 🖥️ TERMINAL & SHELL
    # ═══════════════════════════════════════════════════════════
    
    kitty
    alacritty
    
    # Shell utilities
    eza        # better ls
    bat        # better cat
    ripgrep    # better grep
    fd         # better find
    fzf        # fuzzy finder
    zoxide     # smart cd
    starship   # prompt
    
    # ═══════════════════════════════════════════════════════════
    # 🔧 SYSTEM TOOLS
    # ═══════════════════════════════════════════════════════════
    
    btop
    pavucontrol
    filezilla   # FTP/SFTP client (useful for moving media to/from servers)
    
    # File manager
    pcmanfm
    dolphin    # KDE file manager (pairs well with Kate)
    
    # ═══════════════════════════════════════════════════════════
    # 📸 MEDIA
    # ═══════════════════════════════════════════════════════════
    
    mpv
    imv
    
    # Video / content creation
    ffmpeg                   # Video rendering/transcoding toolkit
    davinci-resolve          # DaVinci Resolve (free) - requires GPU/CUDA/OpenCL
    kdenlive                 # Video editor
    handbrake                # Video transcoder GUI
    yt-dlp                   # Media downloader
    imagemagick              # Image batch processing/conversion
    
    # Screenshot/recording
    grim
    slurp
    wl-clipboard
    obs-studio   # Screen recording
    
    # ═══════════════════════════════════════════════════════════
    # 🎮 GAMES & EMULATION
    # ═══════════════════════════════════════════════════════════
    
    superTuxKart             # Racing game
    retroarch                # Retro gaming emulator frontend
    openage                  # Age of Empires II (open-source engine clone)
  ];

  # ═══════════════════════════════════════════════════════════
  # 🌐 DEFAULT APPLICATIONS
  # ═══════════════════════════════════════════════════════════
  
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Set Brave as default browser
      "text/html" = "brave-browser.desktop";
      "x-scheme-handler/http" = "brave-browser.desktop";
      "x-scheme-handler/https" = "brave-browser.desktop";
      "x-scheme-handler/about" = "brave-browser.desktop";
      "x-scheme-handler/unknown" = "brave-browser.desktop";
      "application/xhtml+xml" = "brave-browser.desktop";
      "application/x-extension-htm" = "brave-browser.desktop";
      "application/x-extension-html" = "brave-browser.desktop";
      "application/x-extension-shtml" = "brave-browser.desktop";
      "application/x-extension-xhtml" = "brave-browser.desktop";
      "application/x-extension-xht" = "brave-browser.desktop";
      
      # Set Kate for text files
      "text/plain" = "org.kde.kate.desktop";
      
      # Set Krita for images (editing)
      "image/png" = "org.kde.krita.desktop";
      "image/jpeg" = "org.kde.krita.desktop";
      
      # Set mpv for video/audio
      "video/mp4" = "mpv.desktop";
      "video/mkv" = "mpv.desktop";
      "audio/mpeg" = "mpv.desktop";
      "audio/flac" = "mpv.desktop";
    };
  };

  # Set default browser environment variable
  home.sessionVariables = {
    BROWSER = "brave";
    DEFAULT_BROWSER = "brave";
  };

  # Program configurations
  programs = {
    # Brave browser configuration
    brave = {
      enable = true;
      extensions = [
        # uBlock Origin
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; }
      ];
    };

    git = {
      enable = true;
      userName = "KOOLSKULL";
      userEmail = "your@email.com"; # Change this!
    };

    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      
      shellAliases = {
        ls = "eza --icons";
        ll = "eza -la --icons";
        cat = "bat";
        ".." = "cd ..";
        "..." = "cd ../..";
        
        # App shortcuts
        blender = "blender";
        tracker = "milkytracker";
        furnace = "furnace";
      };

      initExtra = ''
        eval "$(starship init zsh)"
        eval "$(zoxide init zsh)"
        
        # OpenMPT function (runs via Wine)
        openmpt() {
          if [ ! -f "$HOME/.wine/drive_c/OpenMPT/OpenMPT.exe" ]; then
            echo "OpenMPT not installed. Run 'install-openmpt' first."
          else
            wine "$HOME/.wine/drive_c/OpenMPT/OpenMPT.exe" "$@"
          fi
        }
        
        # OpenMPT installer
        install-openmpt() {
          echo "Downloading OpenMPT..."
          mkdir -p "$HOME/.wine/drive_c/OpenMPT"
          curl -L "https://download.openmpt.org/archive/openmpt/1.31/OpenMPT-1.31.10.00-portable-amd64.zip" -o /tmp/openmpt.zip
          unzip -o /tmp/openmpt.zip -d "$HOME/.wine/drive_c/OpenMPT"
          rm /tmp/openmpt.zip
          echo "OpenMPT installed! Run 'openmpt' to start."
        }
      '';
    };

    starship = {
      enable = true;
      settings = {
        add_newline = true;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[✗](bold red)";
        };
      };
    };

    kitty = {
      enable = true;
      settings = {
        font_family = "JetBrainsMono Nerd Font";
        font_size = 12;
        background_opacity = "0.95";
        confirm_os_window_close = 0;
      };
    };
  };

  # Hyprland configuration
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      
      monitor = ",preferred,auto,1";
      
      exec-once = [
        "waybar"
        "dunst"
      ];
      
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };
      
      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
      };
      
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };
      
      bind = [
        "$mod, Return, exec, kitty"
        "$mod, Q, killactive"
        "$mod, M, exit"
        "$mod, E, exec, dolphin"
        "$mod, V, togglefloating"
        "$mod, D, exec, wofi --show drun"
        "$mod, F, fullscreen"
        
        # App launchers
        "$mod, B, exec, brave"
        "$mod, C, exec, cursor"
        
        # Move focus
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"
        
        # Workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        
        # Move to workspace
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
        
        # Screenshot
        ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
        "SHIFT, Print, exec, grim - | wl-copy"
      ];
      
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      
      # Window rules for apps
      windowrulev2 = [
        "float, class:^(pavucontrol)$"
        "float, class:^(milkytracker)$"
        "float, class:^(furnace)$"
        "size 1200 800, class:^(blender)$"
      ];
    };
  };

  # Home Manager version
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}
