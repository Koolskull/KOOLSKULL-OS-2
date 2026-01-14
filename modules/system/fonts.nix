# Font configuration
{ config, pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = true;
    
    packages = with pkgs; [
      # Nerd Fonts
      (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" "Hack" ]; })
      
      # System fonts
      inter
      roboto
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      
      # Icon fonts
      font-awesome
      material-design-icons
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Inter" ];
        monospace = [ "JetBrainsMono Nerd Font" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
