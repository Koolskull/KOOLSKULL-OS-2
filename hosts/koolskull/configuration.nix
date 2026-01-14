# KOOLSKULL OS - Main System Configuration
{ config, pkgs, pkgs-unstable, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "koolskull";
  networking.networkmanager.enable = true;

  # Timezone and locale
  time.timeZone = "America/New_York"; # Change to your timezone
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # User account
  users.users.kool = {
    isNormalUser = true;
    description = "KOOLSKULL";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
    shell = pkgs.zsh;
  };

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    curl
    htop
    neofetch
  ];

  # Enable OpenSSH
  services.openssh.enable = true;

  # System version - don't change this
  system.stateVersion = "24.05";
}
