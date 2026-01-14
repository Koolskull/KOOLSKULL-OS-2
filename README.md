# KOOLSKULL OS 2

KOOLSKULL OS 2 is a **beginner-friendly NixOS “prebuild”** for a creative workstation: filmmaking, editing, 3D, audio, and general content production.

If you’re new to NixOS, don’t worry: you can **boot a USB installer**, install NixOS, then apply this configuration with one command. After that, updates are just `git pull` + `nixos-rebuild`.

It also includes practical workflow tools you’ll want in real production environments (like **`ffmpeg`** for rendering/transcoding, and an **FTP/SFTP client** for moving assets to/from servers/NAS boxes).

Built with **Hyprland** + **Nix Flakes** + **Home Manager**.

## 🎨 Included Applications

| Category | Applications |
|----------|-------------|
| **3D & Graphics** | Blender (latest via unstable), Krita, GIMP, FreeCAD |
| **Music / Audio** | MilkyTracker, Furnace, Schism Tracker, OpenMPT (via Wine), LMMS, Ardour, Audacity |
| **Video / Media** | ffmpeg, Kdenlive, HandBrake, OBS Studio, mpv |
| **Development** | Cursor IDE, VS Code, Zed, Kate, Redot Engine, Node.js, npm, Bun |
| **Games / Emulation** | SuperTuxKart, RetroArch |
| **Browser** | Brave (default) |
| **Desktop** | Hyprland (Wayland compositor) |

### Why you might want this (even as a beginner)

- **Production-friendly**: common creative apps plus the glue tools that make pipelines work (rendering, conversion, capture, asset transfer).
- **Reproducible**: your setup is described in code; re-installing on a new machine is much easier.
- **Upgradeable**: update apps by updating the flake inputs and rebuilding.

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
│   ├── cursor.nix         # Cursor IDE AppImage package
│   └── redot.nix          # Redot Engine package
└── home/
    └── kool.nix           # Home Manager user configuration
```

## 🚀 Getting Started

## 💾 Install on Real Hardware (Windows + Rufus + USB)

This is the simplest “from Windows to NixOS on a real machine” flow.

### 1) Download the NixOS ISO

- Download a NixOS ISO from the official downloads page: `https://nixos.org/download`
- Recommended: **Minimal ISO** (fastest to install; you’ll use this repo/flake for your actual setup)

### 2) Flash the ISO to a USB drive with Rufus (Windows)

1. Download Rufus: `https://rufus.ie/`
2. Plug in your USB drive (**this will erase it**)
3. Open Rufus:
   - **Device**: select your USB drive
   - **Boot selection**: choose your downloaded NixOS `.iso`
   - **Partition scheme**:
     - **GPT** = modern UEFI PCs (recommended)
     - **MBR** = legacy BIOS/older machines
   - **Target system** will follow your choice (UEFI vs BIOS)
4. Click **START**
5. If Rufus asks **ISO mode vs DD mode**:
   - If you’re not sure: choose **DD mode** (most compatible for Linux installer ISOs)

### 3) Boot from the USB

1. Reboot the target PC
2. Enter the boot menu (common keys: **F12**, **F10**, **Esc**, **Del** — varies by PC)
3. Select the USB drive
4. If you have boot issues:
   - Disable **Secure Boot** in BIOS/UEFI settings (often required)
   - Prefer **UEFI** boot (GPT) on modern systems

### 4) Install NixOS + apply this repo (flake) on the new machine

Once you’re booted into the NixOS installer environment:

1. Connect to the internet
   - Wired usually “just works”
   - For Wi‑Fi you can use `nmtui` (terminal UI)
2. Partition + format your disk (example only; **adjust to your needs**)
   - You need at minimum:
     - An EFI System Partition mounted at `/mnt/boot` (UEFI/GPT installs)
     - A root filesystem mounted at `/mnt`
3. Mount your filesystems under `/mnt`
4. Generate the hardware config:

```bash
sudo nixos-generate-config --root /mnt
```

5. Clone this repo (into the installer environment):

```bash
nix-shell -p git
git clone https://github.com/Koolskull/KOOLSKULL-OS-2.git
cd KOOLSKULL-OS-2
```

6. Copy the generated hardware config into the repo:

```bash
cp /mnt/etc/nixos/hardware-configuration.nix hosts/koolskull/hardware-configuration.nix
```

7. Install NixOS using the flake (this repo):

```bash
sudo nixos-install --root /mnt --flake .#koolskull
```

8. Reboot:

```bash
reboot
```

After reboot, your machine should come up on the KOOLSKULL OS config.

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

### Redot Hash

The Redot package also requires updating the SHA256 hash on first build (same workflow as Cursor):

1. Try to build: `sudo nixos-rebuild switch --flake .#koolskull-vm`
2. Nix will fail and show the correct hash
3. Update `packages/redot.nix` with the correct hash
4. Rebuild

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
