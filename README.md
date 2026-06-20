# ❄️ Dotfiles | NixOS & Hyprland

Welcome to my personal, fully declarative desktop configuration environment built on **NixOS**, managed cleanly via **Nix Flakes** and **Home Manager**.

## 🚀 Key Features
* **OS:** NixOS (Unstable Channel)
* **WM:** Hyprland (Wayland)
* **Bar:** Waybar (with `nm-applet` system tray integration)
* **Notifications:** SwayNC (Custom minimal styling)
* **Clipboard:** `wl-clipboard` (`wl-copy`/`wl-paste`)
* **Automation:** Periodic automatic system garbage collection and store optimization

---

## 📂 Repository Structure

```text
~/dotfiles/
├── flake.nix                  # Flake entry point ( orchestrates system + home-manager )
├── flake.lock                 # Strict dependency lock file
├── nixos/
│   ├── configuration.nix      # Core system-wide settings, packages & options
│   └── hardware-configuration.nix # Local machine hardware parameters (Git ignored)
└── home-manager/
    └── home.nix               # User-specific application environment & dotfiles
```

## 🛠️ Commands & Workflow

This repository uses local absolute path addressing, meaning system rebuilds can be executed securely from any working directory.
Daily System Management

- Rebuild & Switch System:
```Bash
    sudo nixos-rebuild switch --flake ~/dotfiles#nixos
```
	
- Rebuild User Environment (Home Manager Standalone):
```Bash
    home-manager switch --flake ~/dotfiles#yourusername
```

- Update All System Packages:
```Bash
    cd ~/dotfiles && nix flake update
    sudo nixos-rebuild switch --flake ~/dotfiles#nixos
```

### Useful Quality-of-Life Aliases

- Consider mapping shortcuts inside your shell configuration file for swift executions:
```Bash
alias nrs="sudo nixos-rebuild switch --flake ~/dotfiles#nixos"
alias hms="home-manager switch --flake ~/dotfiles#yourusername"
```

## 🧹 System Maintenance

This setup includes automated platform preservation. Every week, the system invokes a silent garbage collection sequence that automatically trims down bloated packages, keeping files only if they are less than 7 days old.

Additionally, auto-optimise-store is enabled to automatically identify duplicated package files across generations and hard-link them together to save massive storage space.

## ⚙️ Fresh Installation / Reproduction

To deploy these exact dotfiles onto a completely fresh NixOS installation:

1. Clone this repository directly into your home path:
```Bash
    git clone [https://github.com/kalanajaya/dotfiles-nix.git](https://github.com/dotfiles/dotfiles-nix.git) ~/dotfiles
```

2. Copy the fresh target machine's unique hardware configuration into the repository structure:
```Bash
    cp /etc/nixos/hardware-configuration.nix ~/dotfiles/nixos/hardware-configuration.nix
```

3. Initialize the compilation state using the local Flake:
```Bash
    sudo nixos-rebuild switch --flake ~/dotfiles#nixos
```
