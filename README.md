# KOOLSKULL OS 2

A custom NixOS configuration with Hyprland, built with Nix Flakes.

## 🎨 Included Applications

| Category | Applications |
|----------|-------------|
| **3D & Graphics** | Blender 5 (latest), Krita |
| **Music Trackers** | Milky Tracker, Furnace, OpenMPT (via Wine) |
| **Development** | Cursor IDE, Kate |
| **Browser** | Brave (default) |
| **Desktop** | Hyprland (Wayland compositor) |

## 📁 Project Structure

```
KOOLSKULL OS 2/
├── flake.nix              # Main flake entry point
├── flake.lock             # Locked dependencies (auto-generated)
├── hosts/
│   ├── koolskull/         # Main hardware configuration
│   │   ├── configuration.nix
│   │   └── hardware-configuration.nix
│   └── vm/                # VM test configuration
│       └── configuration.nix
├── modules/
│   └── system/            # System-level modules
│       ├── default.nix
│       ├── desktop.nix
│       ├── fonts.nix
│       ├── audio.nix
│       └── graphics.nix
├── packages/
│   └── cursor.nix         # Cursor IDE AppImage package
└── home/
    └── kool.nix           # Home Manager user configuration
```

## 🚀 Getting Started

### Option 1: Test in VM (Recommended First Step)

1. **Download NixOS ISO** from https://nixos.org/download
2. **Create a VM** using VirtualBox, Hyper-V, or QEMU
3. **Boot the ISO** and install NixOS
4. **Clone this repo** inside the VM
5. **Build the VM configuration:**
   ```bash
   sudo nixos-rebuild switch --flake .#koolskull-vm
   ```

### Option 2: Build a Custom ISO

```bash
# Build a bootable ISO with your configuration
nix build .#nixosConfigurations.koolskull.config.system.build.isoImage
```

### Option 3: Install on Real Hardware

1. Boot NixOS installer ISO
2. Partition drives and mount at `/mnt`
3. Generate hardware config:
   ```bash
   nixos-generate-config --root /mnt
   ```
4. Copy the generated `/mnt/etc/nixos/hardware-configuration.nix` to `hosts/koolskull/`
5. Clone this repo and build:
   ```bash
   sudo nixos-rebuild switch --flake .#koolskull
   ```

## 🖥️ VM Setup Guide (Windows)

### Using VirtualBox

1. Download [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. Download [NixOS ISO](https://nixos.org/download) (GNOME or Minimal)
3. Create new VM:
   - Type: Linux
   - Version: Other Linux (64-bit)
   - RAM: 4GB+ recommended
   - Disk: 40GB+ (VDI, dynamically allocated)
4. VM Settings:
   - System → Enable EFI (optional, for UEFI boot)
   - Display → Video Memory: 128MB
   - Display → Enable 3D Acceleration
5. Boot the ISO and install NixOS

### Using Hyper-V (Windows Pro/Enterprise)

1. Enable Hyper-V in Windows Features
2. Open Hyper-V Manager
3. Create new VM:
   - Generation 2 (UEFI)
   - RAM: 4GB+
   - Disk: 40GB+
4. Disable Secure Boot in VM settings
5. Boot the NixOS ISO

### Using WSL2 (Limited)

NixOS on WSL2 is possible but limited. See [NixOS-WSL](https://github.com/nix-community/NixOS-WSL).

## 🔧 Common Commands

```bash
# Rebuild system after changes
sudo nixos-rebuild switch --flake .#koolskull

# Test configuration without switching
sudo nixos-rebuild test --flake .#koolskull

# Update flake inputs
nix flake update

# Garbage collect old generations
sudo nix-collect-garbage -d

# List generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```

## 🎨 Customization

### Change Desktop Environment

Edit `modules/system/desktop.nix` to switch between:
- Hyprland (default, Wayland)
- GNOME
- KDE Plasma

### Add Packages

- **System packages:** `hosts/koolskull/configuration.nix`
- **User packages:** `home/kool.nix`

### Change User Settings

Edit `home/kool.nix` for:
- Shell aliases
- Terminal config
- Git settings
- Hyprland keybinds

## 🎹 OpenMPT Setup (Windows Tracker via Wine)

OpenMPT is a Windows application. After first boot, run:

```bash
install-openmpt    # Downloads and installs OpenMPT
openmpt            # Runs OpenMPT
```

## ⚠️ First Build Notes

### Cursor IDE Hash

The Cursor package requires updating the SHA256 hash on first build:

1. Try to build: `sudo nixos-rebuild switch --flake .#koolskull-vm`
2. Nix will fail and show the correct hash
3. Update `packages/cursor.nix` with the correct hash
4. Rebuild

Or get the hash manually:
```bash
nix-prefetch-url --type sha256 "https://downloader.cursor.sh/linux/appImage/x64"
```

## 📝 TODO

- [ ] Add custom wallpapers
- [ ] Configure Waybar theme
- [ ] Add more Hyprland customizations
- [ ] Create installation script
- [ ] Add GPU-specific configs (NVIDIA/AMD)

## 📚 Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Nix Flakes](https://nixos.wiki/wiki/Flakes)
- [Home Manager](https://nix-community.github.io/home-manager/)
- [Hyprland Wiki](https://wiki.hyprland.org/)
