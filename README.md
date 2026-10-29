# ⛏️ Minecraft KDE Plasma 6 Desktop Configuration

[![KDE Plasma 6](https://img.shields.io/badge/KDE-Plasma%206-3daee9?logo=kde&logoColor=white)](https://kde.org/plasma-desktop/)
[![Platform](https://img.shields.io/badge/Platform-Linux-FCC624?logo=linux&logoColor=black)](https://www.kernel.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Style](https://img.shields.io/badge/Theme-Minecraft-55FF55?logo=minecraft&logoColor=white)](https://www.minecraft.net/)

A complete, cohesive, and **portable Minecraft-themed desktop suite for KDE Plasma 6**.

Inspired by the popular Windows customization guide by [Unknown Technology](https://www.youtube.com/watch?v=Kl47s2aDLZg) and resources by [@WasiCustomization](https://wasicustomizations.blogspot.com/) & [D-Meloper's Block HUD](https://github.com/d-meloper/dmelopers-block-hud), this project ports that full experience natively to Linux and KDE Plasma with zero missing dependencies, self-contained assets, and an automated installer.

---

## ✨ Features Overview

### 🎮 1. Creative Inventory Application Launcher (`mc_inventory`)
* **Authentic UI:** Pixel-perfect Minecraft Creative Inventory grid featuring authentic stone borders, tabs, and snap scrollbars.
* **Category Tabs:** Grouped into Building, Combat, Redstone, Utilities, Games, Multimedia, Internet, and Development.
* **Favorites Bar:** 9-slot quick-access bar right below the main grid (right-click any item to toggle).
* **Search & Session Controls:** Real-time search with integrated lock, logout, restart, and shutdown buttons.

### 📊 2. Native Minecraft Desktop HUD Widget (`org.kde.plasma.minecrafthud`)
* **Health Bar (Hearts):** 10 hearts tracking live CPU load or battery status.
* **Hunger Bar (Drumsticks):** 10 drumsticks monitoring live RAM / memory consumption.
* **Armor Bar:** 10 shield/armor icons tracking swap or system load.
* **XP Level & Progress Bar:** Glowing green XP level counter and animated segmented XP bar.
* **9-Slot Interactive Hotbar Dock:**
  * `Slot 1` 🗡 **Diamond Sword** → Terminal (`konsole`)
  * `Slot 2` 🧭 **Compass** → Web Browser (`kde-open https://google.com`)
  * `Slot 3` 📦 **Chest** → File Manager (`dolphin`)
  * `Slot 4` 📖 **Book & Quill** → Text Editor (`kate`)
  * `Slot 5` 🛠 **Crafting Table** → System Settings (`systemsettings`)
  * `Slot 6` 🧨 **TNT** → System Monitor (`plasma-systemmonitor`)
  * `Slot 7` 🎵 **Jukebox** → Music Player (`elisa`)
  * `Slot 8` 💎 **Emerald** → Software Center (`discover`)
  * `Slot 9` 🌋 **Lava Bucket** → Trash Bin (`dolphin trash:/`)
  * *Hover highlights with authentic `slot-highlight.png` and click sounds! Fully customizable in widget settings.*
* **Minecraft Day/Night Clock:** Real-time 64-frame rotating sun and moon item sprite synchronized to the 24-hour day cycle, alongside digital time in pixel font.

### 🖱️ 3. Multi-Size Xcursor Themes
* **`Minecraft-Diamond`:** Iconic Diamond Sword pointer for links/clicks + Minecraft tool cursors.
* **`Minecraft-Classic`:** Authentic in-game GUI cursor pointer, gauntlet, crosshair, and animated busy watch.
* Pre-compiled with crisp nearest-neighbor scaling across **24px, 32px, 48px, and 64px** for high-DPI and 4K displays.

### 🎨 4. Plasma Desktop Theme & Colors
* **Plasma Theme:** 3D stone-beveled panels, dialog windows, hotbar taskbar items, and purple/indigo item tooltip boxes.
* **Color Scheme (`Minecraft.colors`):** Deep stone charcoal backgrounds (`#2B2B2C`), Diamond Cyan highlights (`#4AEDD9`), and XP Green positive accents (`#55FF55`).

### 🔤 5. Minecraft Pixel Fonts
* **`Minecraft.otf` & `Minecraft-Bold.otf`:** Mojang-style pixel font for UI labels, widgets, and headings.
* **`Monocraft.ttc`:** Monospaced pixel programming font for terminal emulators, code editors, and fastfetch.

### 🖼️ 6. Pixel Item Icons (`Minecraft-Pixel-Icons`)
* Popular desktop applications (Browsers, File Managers, Terminals, Editors, Settings, Trash) mapped to iconic Minecraft blocks and items.

### 🌄 7. 4K Shaders Wallpapers
* Curated high-resolution landscapes: Sunset shaders, Cozy Village, Mountain & Meadow, Castle & Ocean, and Starry Night.

### 🔔 8. Authentic Sound Theme
* System event sounds for button clicks, door opens/closes, chest rattles, level-up chimes, note block bells, and item sizzles.

### ⏳ 9. World Loading Splash Screen
* Recreates the Minecraft "Loading World: Building Terrain" startup screen for KDE Plasma boot/login.

### 🔒 10. MineSDDM Login Theme
* SDDM login screen styled after the Minecraft Title Screen with world selection buttons and panoramic backdrop.

### 💻 11. Terminal & Fastfetch
* Ready-to-use Konsole profile and custom Fastfetch Minecraft grass block system banner.

---

## 🚀 Installation

### Automated Installer

Clone this repository and run the installer:

```bash
git clone https://github.com/imyash0722/kde-minecraft-config.git
cd kde-minecraft-config
./install.sh
```

### Installation Options

```bash
# Install everything automatically (Non-interactive)
./install.sh --all

# Install specific components:
./install.sh --hud          # Desktop HUD & Hotbar widget only
./install.sh --cursor       # Diamond & Classic cursor themes only
./install.sh --fonts        # Pixel fonts only
./install.sh --color        # Color scheme only
./install.sh --plasma       # Plasma desktop theme only
./install.sh --wallpapers   # 4K wallpapers only
./install.sh --sounds       # Sound theme only
./install.sh --sddm         # SDDM login theme (uses Polkit pkexec)
```

### Automatic Backup & Restore

Before applying any changes, the installer automatically saves a full backup of your KDE configuration to `~/.kde-minecraft-backup/<timestamp>/`.

To revert back to your previous setup or reset to default Breeze at any time:

```bash
./uninstall.sh
```

---

## 🛠️ Post-Install Configuration Tips

1. **Activate the Creative Inventory Launcher:**
   * Right-click your current application launcher icon on the panel → **Show Alternatives...** → Select **MC Inventory** → Click **Switch**.
2. **Add / Reposition the Desktop HUD:**
   * Right-click the desktop → **Add Widgets...** → Search for **Minecraft HUD** → Drag it anywhere onto your desktop.
   * Right-click the HUD widget → **Configure Minecraft HUD...** to customize hotbar commands, visibility, or scaling.
3. **Switch Cursors:**
   * Open **System Settings** → **Colors & Themes** → **Cursors** → Choose between `Minecraft-Diamond` or `Minecraft-Classic`.
4. **Konsole Profile:**
   * Open Konsole → **Settings** → **Edit Current Profile...** or switch to the installed **Minecraft** profile.

---

## 📂 Project Structure

```
kde-minecraft-config/
├── install.sh                  # Main installer script
├── uninstall.sh                # Restore and uninstaller script
├── setup-hotbar-panel.sh       # Script to auto-place HUD on desktop
├── color-schemes/
│   └── Minecraft.colors        # KDE color scheme
├── fonts/                      # Minecraft & Monocraft fonts
├── wallpapers/                 # 4K Minecraft wallpapers
├── sounds/                     # System event sound theme
├── icons/
│   ├── Minecraft-Diamond/      # Diamond Sword cursor theme
│   ├── Minecraft-Classic/      # Classic Minecraft cursor theme
│   └── Minecraft-Pixel-Icons/  # Application pixel icons
├── plasma/
│   ├── desktoptheme/Minecraft/ # Plasma 6 desktop theme
│   └── plasmoids/
│       ├── mc_inventory/       # Creative Inventory launcher
│       └── org.kde.plasma.minecrafthud/ # Native Desktop HUD widget
├── look-and-feel/              # World Loading splash screen
├── sddm/minesddm/              # Minecraft Title Screen SDDM theme
├── konsole/                    # Konsole color scheme and profile
├── fastfetch/                  # Fastfetch Minecraft banner config
└── conky/                      # Optional Conky HUD alternative
```

---

## 📜 Credits & Attributions

* **Theme Concept & Windows Inspiration:** [Unknown Technology - Windows 11 Minecraft Setup](https://www.youtube.com/watch?v=Kl47s2aDLZg)
* **Start Menu & UI Concept:** [@WasiCustomization / WasiXGamer](https://wasicustomizations.blogspot.com/)
* **HUD Sprites & Audio:** [D-Meloper's Block HUD](https://github.com/d-meloper/dmelopers-block-hud)
* **Application Launcher:** [Calamytryx / MineLauncher](https://github.com/Calamytryx/MineLauncher)
* **Splash Screen:** [Samsu-F / minecraftworldloading-kde-splash](https://github.com/Samsu-F/minecraftworldloading-kde-splash)
* **SDDM Login Theme:** [Davi-S / sddm-theme-minesddm](https://github.com/Davi-S/sddm-theme-minesddm)
* **Fonts:** [IdreesInc / Minecraft-Font](https://github.com/IdreesInc/Minecraft-Font) & [Monocraft](https://github.com/IdreesInc/Monocraft)
* **Minecraft Assets & IP:** [Mojang Studios / Microsoft](https://www.minecraft.net/)

---

## 📄 License

This configuration suite is open-sourced under the [MIT License](LICENSE). Third-party assets and trademarks belong to their respective creators and Mojang Studios.
