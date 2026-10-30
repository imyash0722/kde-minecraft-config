#!/usr/bin/env bash
# ==============================================================================
# Minecraft KDE Plasma 6 Desktop Configuration Installer
# Fully portable, cohesive Minecraft theme suite for KDE Plasma
# ==============================================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ANSI Color Codes
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

print_banner() {
    echo -e "${CYAN}"
    echo "  ███╗   ███╗██╗███╗   ██╗███████╗ ██████╗██████╗  █████╗ ███████╗████████╗"
    echo "  ████╗ ████║██║████╗  ██║██╔════╝██╔════╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝"
    echo "  ██╔████╔██║██║██╔██╗ ██║█████╗  ██║     ██████╔╝███████║█████╗     ██║   "
    echo "  ██║╚██╔╝██║██║██║╚██╗██║██╔══╝  ██║     ██╔══██╗██╔══██║██╔══╝     ██║   "
    echo "  ██║ ╚═╝ ██║██║██║ ╚████║███████╗╚██████╗██║  ██║██║  ██║██║        ██║   "
    echo "  ╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝        ╚═╝   "
    echo -e "${YELLOW}                 ✦ Portable KDE Plasma 6 Theme Suite ✦${NC}\n"
}

# Detection helpers
DETECTED_KDE_VER="unknown"
if command -v plasmashell >/dev/null 2>&1; then
    DETECTED_KDE_VER=$(plasmashell --version 2>/dev/null || echo "6")
fi

KPACKAGETOOL="kpackagetool6"
KWRITECONFIG="kwriteconfig6"
if ! command -v kpackagetool6 >/dev/null 2>&1; then
    if command -v kpackagetool5 >/dev/null 2>&1; then
        KPACKAGETOOL="kpackagetool5"
        KWRITECONFIG="kwriteconfig5"
    fi
fi

# Flags
FLAG_ALL=false
FLAG_FONTS=false
FLAG_COLOR=false
FLAG_CURSOR=false
FLAG_ICONS=false
FLAG_PLASMA=false
FLAG_WALLPAPERS=false
FLAG_SOUNDS=false
FLAG_WIDGETS=false
FLAG_SPLASH=false
FLAG_TERMINAL=false
FLAG_SDDM=false
FLAG_AUTO_DESKTOP_HUD=false

parse_args() {
    if [ "$#" -eq 0 ]; then
        return 0
    fi

    while [[ "$#" -gt 0 ]]; do
        case $1 in
            -a|--all|--silent)
                FLAG_ALL=true
                FLAG_FONTS=true
                FLAG_COLOR=true
                FLAG_CURSOR=true
                FLAG_ICONS=true
                FLAG_PLASMA=true
                FLAG_WALLPAPERS=true
                FLAG_SOUNDS=true
                FLAG_WIDGETS=true
                FLAG_SPLASH=true
                FLAG_TERMINAL=true
                FLAG_AUTO_DESKTOP_HUD=true
                shift
                ;;
            --fonts)
                FLAG_FONTS=true
                shift
                ;;
            --color)
                FLAG_COLOR=true
                shift
                ;;
            --cursor)
                FLAG_CURSOR=true
                shift
                ;;
            --icons)
                FLAG_ICONS=true
                shift
                ;;
            --plasma)
                FLAG_PLASMA=true
                shift
                ;;
            --wallpapers)
                FLAG_WALLPAPERS=true
                shift
                ;;
            --sounds)
                FLAG_SOUNDS=true
                shift
                ;;
            --widgets|--hud)
                FLAG_WIDGETS=true
                FLAG_AUTO_DESKTOP_HUD=true
                shift
                ;;
            --splash)
                FLAG_SPLASH=true
                shift
                ;;
            --terminal)
                FLAG_TERMINAL=true
                shift
                ;;
            --sddm)
                FLAG_SDDM=true
                shift
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                echo -e "${RED}Unknown option: $1${NC}"
                show_help
                exit 1
                ;;
        esac
    done
}

show_help() {
    print_banner
    echo -e "${BOLD}Usage:${NC} ./install.sh [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -a, --all, --silent  Install all user-level components automatically"
    echo "  --hud, --widgets     Install Desktop HUD & Inventory Launcher applets"
    echo "  --cursor             Install Diamond Sword & Classic Minecraft cursor sets"
    echo "  --fonts              Install Minecraft & Monocraft pixel fonts"
    echo "  --color              Install Minecraft GUI Dark Color Scheme"
    echo "  --plasma             Install Minecraft Plasma Desktop Theme"
    echo "  --icons              Install Minecraft Pixel Item Icons"
    echo "  --wallpapers         Install 4K Minecraft shader wallpapers"
    echo "  --sounds             Install Minecraft system sound theme"
    echo "  --splash             Install World Loading Splash Screen"
    echo "  --terminal           Install Konsole & Fastfetch configs"
    echo "  --sddm               Install SDDM Login Theme (requires Polkit pkexec)"
    echo "  -h, --help           Show this help message"
    echo ""
    echo "If run without arguments, an interactive menu will be displayed."
}

create_backup() {
    local backup_dir="$HOME/.kde-minecraft-backup/$(date +%Y%m%d_%H%M%S)"
    echo -e "${CYAN}📦 Creating configuration backup at: ${backup_dir}${NC}"
    mkdir -p "$backup_dir"
    
    for cfg in kdeglobals plasmarc plasma-org.kde.plasma.desktop-appletsrc kcminputrc kwinrc ksplashrc; do
        if [ -f "$HOME/.config/$cfg" ]; then
            cp "$HOME/.config/$cfg" "$backup_dir/" 2>/dev/null || true
        fi
    done
    echo -e "${GREEN}✔ Backup completed.${NC}\n"
}

install_fonts() {
    echo -e "${YELLOW}🔤 Installing Minecraft pixel fonts...${NC}"
    local font_dir="$HOME/.local/share/fonts/minecraft"
    mkdir -p "$font_dir"
    cp "$SCRIPT_DIR"/fonts/* "$font_dir/"
    if command -v fc-cache >/dev/null 2>&1; then
        fc-cache -f "$font_dir" >/dev/null 2>&1 || true
    fi
    echo -e "${GREEN}✔ Installed Minecraft.otf, Minecraft-Bold.otf, Monocraft.ttc${NC}"
}

install_color_scheme() {
    echo -e "${YELLOW}🎨 Installing Minecraft Color Scheme...${NC}"
    local color_dir="$HOME/.local/share/color-schemes"
    mkdir -p "$color_dir"
    cp "$SCRIPT_DIR/color-schemes/Minecraft.colors" "$color_dir/"
    if command -v plasma-apply-colorscheme >/dev/null 2>&1; then
        plasma-apply-colorscheme Minecraft >/dev/null 2>&1 || true
    fi
    echo -e "${GREEN}✔ Minecraft color scheme installed and applied.${NC}"
}

install_cursor_themes() {
    echo -e "${YELLOW}🖱  Installing Minecraft Cursor Themes (Diamond Sword & Classic)...${NC}"
    local icon_base="$HOME/.local/share/icons"
    mkdir -p "$icon_base"
    cp -r "$SCRIPT_DIR/icons/Minecraft-Diamond" "$icon_base/"
    cp -r "$SCRIPT_DIR/icons/Minecraft-Classic" "$icon_base/"
    if command -v plasma-apply-cursortheme >/dev/null 2>&1; then
        plasma-apply-cursortheme Minecraft-Diamond >/dev/null 2>&1 || true
    fi
    echo -e "${GREEN}✔ Installed Minecraft-Diamond and Minecraft-Classic cursors.${NC}"
}

install_icons() {
    echo -e "${YELLOW}🖼  Installing Minecraft Pixel Icon Theme...${NC}"
    local icon_base="$HOME/.local/share/icons"
    mkdir -p "$icon_base"
    cp -r "$SCRIPT_DIR/icons/Minecraft-Pixel-Icons" "$icon_base/"
    if command -v gtk-update-icon-cache >/dev/null 2>&1; then
        gtk-update-icon-cache -f "$icon_base/Minecraft-Pixel-Icons" >/dev/null 2>&1 || true
    fi
    echo -e "${GREEN}✔ Installed Minecraft-Pixel-Icons.${NC}"
}

install_plasma_theme() {
    echo -e "${YELLOW}🖥  Installing Minecraft Plasma Desktop Theme...${NC}"
    local theme_base="$HOME/.local/share/plasma/desktoptheme"
    mkdir -p "$theme_base"
    cp -r "$SCRIPT_DIR/plasma/desktoptheme/Minecraft" "$theme_base/"
    if command -v plasma-apply-desktoptheme >/dev/null 2>&1; then
        plasma-apply-desktoptheme Minecraft >/dev/null 2>&1 || true
    fi
    echo -e "${GREEN}✔ Installed and applied Minecraft Plasma Desktop Theme.${NC}"
}

install_wallpapers() {
    echo -e "${YELLOW}🌄 Installing Minecraft 4K Wallpapers...${NC}"
    local wall_dir="$HOME/.local/share/wallpapers"
    mkdir -p "$wall_dir"
    cp "$SCRIPT_DIR"/wallpapers/* "$wall_dir/"
    if command -v plasma-apply-wallpaperimage >/dev/null 2>&1; then
        plasma-apply-wallpaperimage "$wall_dir/Minecraft_Tricky_Trials.png" >/dev/null 2>&1 || true
    fi
    echo -e "${GREEN}✔ Wallpapers installed to $wall_dir and applied Minecraft_Tricky_Trials.png.${NC}"
}

install_sound_theme() {
    echo -e "${YELLOW}🔔 Installing Minecraft Sound Theme...${NC}"
    local sound_dir="$HOME/.local/share/sounds"
    mkdir -p "$sound_dir"
    cp -r "$SCRIPT_DIR/sounds/Minecraft" "$sound_dir/"
    if command -v "$KWRITECONFIG" >/dev/null 2>&1; then
        "$KWRITECONFIG" --file kdeglobals --group Sounds --key Theme "Minecraft" || true
    fi
    echo -e "${GREEN}✔ Minecraft system event sounds installed and activated.${NC}"
}

install_widgets() {
    echo -e "${YELLOW}📦 Installing Minecraft Plasmoids (Inventory Launcher & Desktop HUD)...${NC}"
    local plasmoid_dir="$HOME/.local/share/plasma/plasmoids"
    mkdir -p "$plasmoid_dir"

    # Copy files directly
    rm -rf "$plasmoid_dir/mc_inventory" "$plasmoid_dir/org.kde.plasma.minecrafthud"
    cp -r "$SCRIPT_DIR/plasma/plasmoids/mc_inventory" "$plasmoid_dir/"
    cp -r "$SCRIPT_DIR/plasma/plasmoids/org.kde.plasma.minecrafthud" "$plasmoid_dir/"

    # Register via kpackagetool if available
    if command -v "$KPACKAGETOOL" >/dev/null 2>&1; then
        "$KPACKAGETOOL" --type Plasma/Applet -u "$plasmoid_dir/mc_inventory" >/dev/null 2>&1 || \
        "$KPACKAGETOOL" --type Plasma/Applet -i "$plasmoid_dir/mc_inventory" >/dev/null 2>&1 || true

        "$KPACKAGETOOL" --type Plasma/Applet -u "$plasmoid_dir/org.kde.plasma.minecrafthud" >/dev/null 2>&1 || \
        "$KPACKAGETOOL" --type Plasma/Applet -i "$plasmoid_dir/org.kde.plasma.minecrafthud" >/dev/null 2>&1 || true
    fi

    echo -e "${GREEN}✔ Installed 'MC Inventory' Launcher and 'Minecraft HUD' widgets.${NC}"

    if [ "$FLAG_AUTO_DESKTOP_HUD" = true ]; then
        if [ -x "$SCRIPT_DIR/setup-hotbar-panel.sh" ]; then
            "$SCRIPT_DIR/setup-hotbar-panel.sh" || true
        fi
    fi
}

install_splash() {
    echo -e "${YELLOW}⏳ Installing Minecraft World Loading Splash Screen...${NC}"
    local lnf_dir="$HOME/.local/share/plasma/look-and-feel"
    mkdir -p "$lnf_dir"
    cp -r "$SCRIPT_DIR/look-and-feel/org.kde.minecraft.desktop" "$lnf_dir/"
    
    if command -v "$KWRITECONFIG" >/dev/null 2>&1; then
        "$KWRITECONFIG" --file ksplashrc --group KSplash --key Theme "org.kde.minecraft.desktop" || true
    fi
    echo -e "${GREEN}✔ World Loading splash screen activated.${NC}"
}

install_terminal() {
    echo -e "${YELLOW}💻 Installing Terminal (Konsole) & Fastfetch Themes...${NC}"
    local konsole_dir="$HOME/.local/share/konsole"
    mkdir -p "$konsole_dir"
    cp "$SCRIPT_DIR/konsole/Minecraft.colorscheme" "$konsole_dir/"
    cp "$SCRIPT_DIR/konsole/Minecraft.profile" "$konsole_dir/"

    local fastfetch_dir="$HOME/.config/fastfetch"
    mkdir -p "$fastfetch_dir"
    cp "$SCRIPT_DIR/fastfetch/config.jsonc" "$fastfetch_dir/"
    cp "$SCRIPT_DIR/fastfetch/minecraft_block.txt" "$fastfetch_dir/" 2>/dev/null || true
    cp "$SCRIPT_DIR/fastfetch/minecraft_sword.txt" "$fastfetch_dir/" 2>/dev/null || true

    echo -e "${GREEN}✔ Konsole profile and Fastfetch Minecraft config installed.${NC}"
}

install_sddm() {
    echo -e "\n${BOLD}${YELLOW}=== SDDM Login Theme Installation ===${NC}"
    echo -e "Installing the 'MineSDDM' login theme requires system root privileges."
    echo -e "Target directory: ${BOLD}/usr/share/sddm/themes/minesddm${NC}"
    echo -e "Configuration: ${BOLD}/etc/sddm.conf.d/kde_settings.conf${NC}"
    echo -e "\n${CYAN}Notice: Authentication will be requested via Polkit ('pkexec').${NC}"
    
    read -p "Do you want to proceed with SDDM theme installation? [y/N]: " SDDM_CONFIRM
    if [[ "$SDDM_CONFIRM" =~ ^[Yy]$ ]]; then
        if command -v pkexec >/dev/null 2>&1; then
            echo -e "${CYAN}Running pkexec to copy theme and apply configuration...${NC}"
            pkexec bash -c "
                mkdir -p /usr/share/sddm/themes/
                cp -r '$SCRIPT_DIR/sddm/minesddm' /usr/share/sddm/themes/
                mkdir -p /etc/sddm.conf.d/
                if command -v kwriteconfig6 >/dev/null 2>&1; then
                    kwriteconfig6 --file /etc/sddm.conf.d/kde_settings.conf --group Theme --key Current 'minesddm'
                elif command -v kwriteconfig5 >/dev/null 2>&1; then
                    kwriteconfig5 --file /etc/sddm.conf.d/kde_settings.conf --group Theme --key Current 'minesddm'
                fi
            "
            echo -e "${GREEN}✔ MineSDDM login theme installed successfully!${NC}"
        else
            echo -e "${RED}Error: pkexec not found. Cannot elevate privileges.${NC}"
        fi
    else
        echo -e "${YELLOW}Skipped SDDM theme installation.${NC}"
    fi
}

interactive_menu() {
    print_banner
    echo -e "${BOLD}Detected Environment:${NC} KDE Plasma (${DETECTED_KDE_VER})"
    echo ""
    echo -e "Select components to install:"
    echo -e "  ${BOLD}1)${NC} ${GREEN}Full Minecraft Experience (All user components - Recommended)${NC}"
    echo -e "  ${BOLD}2)${NC} Desktop HUD & Hotbar Widget only"
    echo -e "  ${BOLD}3)${NC} Application Launcher (MC Inventory) only"
    echo -e "  ${BOLD}4)${NC} Cursor Themes (Diamond Sword & Classic) only"
    echo -e "  ${BOLD}5)${NC} Fonts, Color Scheme & Plasma Style"
    echo -e "  ${BOLD}6)${NC} Wallpapers & Sounds only"
    echo -e "  ${BOLD}7)${NC} SDDM Login Theme (MineSDDM)"
    echo -e "  ${BOLD}8)${NC} Restore previous settings (Uninstall)"
    echo -e "  ${BOLD}0)${NC} Exit"
    echo ""
    read -p "Enter choice [1-8, default=1]: " CHOICE
    CHOICE=${CHOICE:-1}

    case $CHOICE in
        1)
            FLAG_FONTS=true
            FLAG_COLOR=true
            FLAG_CURSOR=true
            FLAG_ICONS=true
            FLAG_PLASMA=true
            FLAG_WALLPAPERS=true
            FLAG_SOUNDS=true
            FLAG_WIDGETS=true
            FLAG_SPLASH=true
            FLAG_TERMINAL=true
            FLAG_AUTO_DESKTOP_HUD=true
            ;;
        2)
            FLAG_FONTS=true
            FLAG_WIDGETS=true
            FLAG_AUTO_DESKTOP_HUD=true
            ;;
        3)
            FLAG_FONTS=true
            FLAG_WIDGETS=true
            ;;
        4)
            FLAG_CURSOR=true
            ;;
        5)
            FLAG_FONTS=true
            FLAG_COLOR=true
            FLAG_PLASMA=true
            FLAG_ICONS=true
            ;;
        6)
            FLAG_WALLPAPERS=true
            FLAG_SOUNDS=true
            ;;
        7)
            install_sddm
            exit 0
            ;;
        8)
            "$SCRIPT_DIR/uninstall.sh"
            exit 0
            ;;
        0)
            echo "Exiting."
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid choice.${NC}"
            exit 1
            ;;
    esac
}

main() {
    parse_args "$@"

    if [ "$FLAG_ALL" = false ] && [ "$FLAG_FONTS" = false ] && [ "$FLAG_COLOR" = false ] && \
       [ "$FLAG_CURSOR" = false ] && [ "$FLAG_ICONS" = false ] && [ "$FLAG_PLASMA" = false ] && \
       [ "$FLAG_WALLPAPERS" = false ] && [ "$FLAG_SOUNDS" = false ] && [ "$FLAG_WIDGETS" = false ] && \
       [ "$FLAG_SPLASH" = false ] && [ "$FLAG_TERMINAL" = false ] && [ "$FLAG_SDDM" = false ]; then
        interactive_menu
    else
        print_banner
    fi

    create_backup

    if [ "$FLAG_FONTS" = true ]; then install_fonts; fi
    if [ "$FLAG_COLOR" = true ]; then install_color_scheme; fi
    if [ "$FLAG_CURSOR" = true ]; then install_cursor_themes; fi
    if [ "$FLAG_ICONS" = true ]; then install_icons; fi
    if [ "$FLAG_PLASMA" = true ]; then install_plasma_theme; fi
    if [ "$FLAG_WALLPAPERS" = true ]; then install_wallpapers; fi
    if [ "$FLAG_SOUNDS" = true ]; then install_sound_theme; fi
    if [ "$FLAG_WIDGETS" = true ]; then install_widgets; fi
    if [ "$FLAG_SPLASH" = true ]; then install_splash; fi
    if [ "$FLAG_TERMINAL" = true ]; then install_terminal; fi
    if [ "$FLAG_SDDM" = true ]; then install_sddm; fi

    echo -e "\n${CYAN}=====================================================${NC}"
    echo -e "${GREEN}${BOLD}✔ Minecraft KDE configuration successfully installed!${NC}"
    echo -e "${CYAN}=====================================================${NC}"
    echo -e "✦ ${YELLOW}Desktop HUD:${NC} Added to desktop. Right-click HUD -> 'Configure Minecraft HUD...' to adjust slots/scale."
    echo -e "✦ ${YELLOW}Start Menu:${NC} Right-click your application launcher icon -> 'Show Alternatives...' -> select 'MC Inventory'."
    echo -e "✦ ${YELLOW}Cursors:${NC} 'Minecraft-Diamond' is applied! 'Minecraft-Classic' is also available in System Settings -> Cursors."
    echo -e "✦ ${YELLOW}Konsole:${NC} Open Konsole -> Settings -> Switch to 'Minecraft' profile."
    echo -e "✦ ${YELLOW}Fastfetch:${NC} Run 'fastfetch' in your terminal to see the Minecraft theme banner."
    echo -e "✦ ${YELLOW}Restore:${NC} Run './uninstall.sh' at any time to restore your previous configuration."
    echo ""
}

main "$@"
