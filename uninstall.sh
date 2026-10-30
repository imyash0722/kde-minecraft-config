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

AUTO_CONFIRM=false
if [[ "$1" == "-a" || "$1" == "--all" || "$1" == "--silent" || "$1" == "-y" ]]; then
    AUTO_CONFIRM=true
fi

echo -e "${CYAN}=====================================================${NC}"
echo -e "${YELLOW}  ⛏  Minecraft KDE Theme Uninstaller & Restore Tool  ${NC}"
echo -e "${CYAN}=====================================================${NC}"

# 1. Remove HUD & Inventory widgets from active Plasma desktop
echo -e "${YELLOW}Removing Minecraft widgets from active desktop...${NC}"
JS_SCRIPT=$(cat << 'JSEOF'
var allDesktops = desktops();
for (var i = 0; i < allDesktops.length; ++i) {
    var d = allDesktops[i];
    var widgets = d.widgets();
    for (var j = widgets.length - 1; j >= 0; --j) {
        if (widgets[j].type === "org.kde.plasma.minecrafthud" || widgets[j].type === "mc_inventory") {
            widgets[j].remove();
        }
    }
}
JSEOF
)

if command -v qdbus6 >/dev/null 2>&1; then
    qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "$JS_SCRIPT" 2>/dev/null || true
elif command -v qdbus >/dev/null 2>&1; then
    qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "$JS_SCRIPT" 2>/dev/null || true
fi

# 2. Restore backed up configuration files
RESTORED_BACKUP=false
BACKUP_BASE="$HOME/.kde-minecraft-backup"
if [ -d "$BACKUP_BASE" ]; then
    LATEST_BACKUP=$(ls -td "$BACKUP_BASE"/*/ 2>/dev/null | head -n 1)
    if [ -n "$LATEST_BACKUP" ] && [ -d "$LATEST_BACKUP" ]; then
        echo -e "${GREEN}Found backup at: ${LATEST_BACKUP}${NC}"
        RESTORE_CONFIRM="Y"
        if [ "$AUTO_CONFIRM" = false ]; then
            read -p "Restore settings from this backup? [Y/n]: " RESTORE_CONFIRM
            RESTORE_CONFIRM=${RESTORE_CONFIRM:-Y}
        fi
        if [[ "$RESTORE_CONFIRM" =~ ^[Yy]$ ]]; then
            echo -e "${CYAN}Restoring configuration files to ~/.config/...${NC}"
            cp -rf "$LATEST_BACKUP"/* "$HOME/.config/" 2>/dev/null || true
            rm -f "$HOME/.config/ksplashrc" 2>/dev/null || true
            RESTORED_BACKUP=true
            echo -e "${GREEN}✔ Config files restored from backup.${NC}"
        fi
    fi
fi

# 3. Fallback reset to Breeze only if no backup was restored
if [ "$RESTORED_BACKUP" = false ]; then
    echo -e "${YELLOW}No backup restored; resetting KDE Plasma themes to default Breeze...${NC}"

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
fi

# Unregister plasmoids with kpackagetool if available
if command -v kpackagetool6 >/dev/null 2>&1; then
    kpackagetool6 --type Plasma/Applet --remove org.kde.plasma.minecrafthud >/dev/null 2>&1 || true
    kpackagetool6 --type Plasma/Applet --remove mc_inventory >/dev/null 2>&1 || true
elif command -v kpackagetool5 >/dev/null 2>&1; then
    kpackagetool5 --type Plasma/Applet --remove org.kde.plasma.minecrafthud >/dev/null 2>&1 || true
    kpackagetool5 --type Plasma/Applet --remove mc_inventory >/dev/null 2>&1 || true
fi

# 4. Remove installed theme assets
CLEAN_FILES="Y"
if [ "$AUTO_CONFIRM" = false ]; then
    read -p "Do you want to remove installed Minecraft theme files from ~/.local/share/? [y/N]: " CLEAN_FILES
fi

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
    rm -f "$HOME/.local/share/konsole/Minecraft.colorscheme" "$HOME/.local/share/konsole/Minecraft.profile" 2>/dev/null || true
    rm -f "$HOME/.local/share/wallpapers/MC-"* "$HOME/.local/share/wallpapers/Minecraft_"* 2>/dev/null || true
    rm -f "$HOME/.config/fastfetch/minecraft_block.txt" "$HOME/.config/fastfetch/minecraft_sword.txt" 2>/dev/null || true
    rm -f "$HOME/.config/fastfetch/config.jsonc" 2>/dev/null || true
    fc-cache -f "$HOME/.local/share/fonts" 2>/dev/null || true
    echo -e "${GREEN}✔ Theme assets cleaned.${NC}"
fi

# 5. Restart plasmashell if currently in a KDE Plasma session
if [[ "$XDG_CURRENT_DESKTOP" =~ (KDE|Plasma|plasma) ]]; then
    echo -e "${CYAN}Restarting Plasma shell...${NC}"
    if systemctl --user is-active --quiet plasma-plasmashell.service 2>/dev/null; then
        systemctl --user restart plasma-plasmashell.service 2>/dev/null || true
    else
        kquitapp6 plasmashell 2>/dev/null || killall plasmashell 2>/dev/null || true
        systemctl --user start plasma-plasmashell.service 2>/dev/null || nohup plasmashell >/dev/null 2>&1 &
    fi
else
    # In non-KDE environments (such as Hyprland), ensure any lingering plasmashell process is stopped
    killall plasmashell 2>/dev/null || true
fi

echo -e "\n${GREEN}✔ Uninstallation complete. System restored to default!${NC}"
