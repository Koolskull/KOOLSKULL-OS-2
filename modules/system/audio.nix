# Audio configuration with PipeWire
{ config, pkgs, ... }:

{
  # Disable PulseAudio
  hardware.pulseaudio.enable = false;

  # Enable sound with PipeWire
  security.rtkit.enable = true;
  
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    
    # Low-latency configuration
    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 512;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 1024;
      };
    };
  };
}
