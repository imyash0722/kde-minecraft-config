#!/usr/bin/env bash
# ==============================================================================
# Minecraft KDE Theme - Uninstaller & Restore Tool
# ==============================================================================
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}=====================================================${NC}"
echo -e "${YELLOW}  ⛏  Minecraft KDE Theme Uninstaller & Restore Tool  ${NC}"
echo -e "${CYAN}=====================================================${NC}"

BACKUP_BASE="$HOME/.kde-minecraft-backup"

if [ -d "$BACKUP_BASE" ]; then
    LATEST_BACKUP=$(ls -td "$BACKUP_BASE"/*/ 2>/dev/null | head -n 1)
    if [ -n "$LATEST_BACKUP" ] && [ -d "$LATEST_BACKUP" ]; then
        echo -e "${GREEN}Found backup at: ${LATEST_BACKUP}${NC}"
        read -p "Restore settings from this backup? [Y/n]: " RESTORE_CONFIRM
        RESTORE_CONFIRM=${RESTORE_CONFIRM:-Y}
        if [[ "$RESTORE_CONFIRM" =~ ^[Yy]$ ]]; then
            echo -e "${CYAN}Restoring configuration files...${NC}"
            cp -r "$LATEST_BACKUP"/* "$HOME/.config/" 2>/dev/null || true
            echo -e "${GREEN}✔ Config files restored from backup.${NC}"
        fi
    fi
fi

echo -e "${YELLOW}Resetting KDE Plasma themes to default Breeze...${NC}"

if command -v plasma-apply-colorscheme >/dev/null 2>&1; then
    plasma-apply-colorscheme BreezeDark 2>/dev/null || plasma-apply-colorscheme Breeze 2>/dev/null || true
fi

if command -v plasma-apply-cursortheme >/dev/null 2>&1; then
    plasma-apply-cursortheme breeze_cursors 2>/dev/null || true
fi

if command -v plasma-apply-desktoptheme >/dev/null 2>&1; then
    plasma-apply-desktoptheme breeze-dark 2>/dev/null || plasma-apply-desktoptheme default 2>/dev/null || true
fi

if command -v kwriteconfig6 >/dev/null 2>&1; then
    kwriteconfig6 --file ksplashrc --group KSplash --key Theme "org.kde.breeze.desktop" 2>/dev/null || true
    kwriteconfig6 --file kdeglobals --group Sounds --key Theme "ocean" 2>/dev/null || true
elif command -v kwriteconfig5 >/dev/null 2>&1; then
    kwriteconfig5 --file ksplashrc --group KSplash --key Theme "org.kde.breeze.desktop" 2>/dev/null || true
    kwriteconfig5 --file kdeglobals --group Sounds --key Theme "ocean" 2>/dev/null || true
fi

read -p "Do you want to remove installed Minecraft theme files from ~/.local/share/? [y/N]: " CLEAN_FILES
if [[ "$CLEAN_FILES" =~ ^[Yy]$ ]]; then
    echo -e "${CYAN}Removing theme assets...${NC}"
    rm -rf "$HOME/.local/share/fonts/minecraft" 2>/dev/null || true
    rm -f "$HOME/.local/share/color-schemes/Minecraft.colors" 2>/dev/null || true
    rm -rf "$HOME/.local/share/icons/Minecraft-Diamond" 2>/dev/null || true
    rm -rf "$HOME/.local/share/icons/Minecraft-Classic" 2>/dev/null || true
    rm -rf "$HOME/.local/share/icons/Minecraft-Pixel-Icons" 2>/dev/null || true
    rm -rf "$HOME/.local/share/plasma/desktoptheme/Minecraft" 2>/dev/null || true
    rm -rf "$HOME/.local/share/plasma/plasmoids/mc_inventory" 2>/dev/null || true
    rm -rf "$HOME/.local/share/plasma/plasmoids/org.kde.plasma.minecrafthud" 2>/dev/null || true
    rm -rf "$HOME/.local/share/plasma/look-and-feel/org.kde.minecraft.desktop" 2>/dev/null || true
    rm -rf "$HOME/.local/share/sounds/Minecraft" 2>/dev/null || true
    fc-cache -f "$HOME/.local/share/fonts" 2>/dev/null || true
    echo -e "${GREEN}✔ Theme assets cleaned.${NC}"
fi

echo -e "\n${GREEN}✔ Uninstallation complete. Please log out and back in to see all changes.${NC}"
