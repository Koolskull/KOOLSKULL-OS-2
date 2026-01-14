# Desktop environment configuration
{ config, pkgs, ... }:

{
  # X11 / Display server
  services.xserver = {
    enable = true;
    
    # Display manager
    displayManager.gdm.enable = true;
    
    # Desktop environment - choose one:
    # Option 1: GNOME
    # desktopManager.gnome.enable = true;
    
    # Option 2: KDE Plasma
    # desktopManager.plasma5.enable = true;
    
    # Option 3: Hyprland (uncomment hyprland section below instead)
  };

  # Option 4: Hyprland (Wayland compositor)
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # XDG Portal for screen sharing, file picking, etc.
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  # Enable programs
  programs.zsh.enable = true;
  programs.dconf.enable = true;
}
