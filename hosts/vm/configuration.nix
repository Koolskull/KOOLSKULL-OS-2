# KOOLSKULL OS - VM Test Configuration
{ config, pkgs, pkgs-unstable, inputs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ../../modules/system
  ];

  # VM-specific bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  # Networking
  networking.hostName = "koolskull-vm";
  networking.networkmanager.enable = true;

  # Timezone and locale
  time.timeZone = "America/New_York";
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
    initialPassword = "changeme"; # Change on first login!
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

  # VM-specific settings
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  # Enable OpenSSH for easy access
  services.openssh.enable = true;

  # Filesystem for VM
  fileSystems."/" = {
    device = "/dev/vda1";
    fsType = "ext4";
  };

  swapDevices = [ ];

  # System version
  system.stateVersion = "24.05";
}
