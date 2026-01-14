# Graphics and GPU configuration
# Required for Blender, Krita, and other GPU-accelerated apps
{ config, pkgs, lib, ... }:

{
  # OpenGL support
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    
    extraPackages = with pkgs; [
      # Vulkan
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
      
      # VA-API (video acceleration)
      vaapiVdpau
      libvdpau-va-gl
      
      # Intel (uncomment if using Intel GPU)
      # intel-media-driver
      # vaapiIntel
      
      # AMD (uncomment if using AMD GPU)
      # rocm-opencl-icd
      # rocm-opencl-runtime
      # amdvlk
    ];
    
    extraPackages32 = with pkgs.pkgsi686Linux; [
      vulkan-loader
    ];
  };

  # For NVIDIA GPUs (uncomment if using NVIDIA)
  # services.xserver.videoDrivers = [ "nvidia" ];
  # hardware.nvidia = {
  #   modesetting.enable = true;
  #   powerManagement.enable = false;
  #   open = false;
  #   nvidiaSettings = true;
  #   package = config.boot.kernelPackages.nvidiaPackages.stable;
  # };

  # Environment variables for Wayland + GPU apps
  environment.sessionVariables = {
    # Blender CUDA/OpenCL support
    CYCLES_CUDA_ENABLED = "1";
    
    # Wayland-native for Electron apps (Cursor)
    NIXOS_OZONE_WL = "1";
    
    # Qt theming
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };

  # Packages for GPU monitoring
  environment.systemPackages = with pkgs; [
    glxinfo
    vulkan-tools
    gpu-viewer
    nvtop  # GPU monitoring (works with all GPUs)
  ];
}
