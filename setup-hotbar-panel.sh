#!/usr/bin/env bash
# ==============================================================================
# Minecraft KDE - Setup Desktop HUD & Hotbar
# Adds the Minecraft HUD widget to your KDE Plasma desktop
# ==============================================================================
set -e

echo "⛏  Configuring Minecraft Desktop HUD in KDE Plasma..."

JS_SCRIPT=$(cat << 'JSEOF'
var allDesktops = desktops();
for (var i = 0; i < allDesktops.length; ++i) {
    var d = allDesktops[i];
    var widgets = d.widgets();
    var exists = false;
    for (var j = 0; j < widgets.length; ++j) {
        if (widgets[j].type === "org.kde.plasma.minecrafthud") {
            exists = true;
            break;
        }
    }
    if (!exists) {
        var hud = d.addWidget("org.kde.plasma.minecrafthud");
        hud.currentConfigGroup = ["General"];
        hud.writeConfig("showClock", true);
        hud.writeConfig("showIndicators", true);
        hud.writeConfig("showHotbar", true);
    }
}
JSEOF
)

if command -v qdbus6 >/dev/null 2>&1; then
    qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "$JS_SCRIPT" || true
elif command -v qdbus >/dev/null 2>&1; then
    qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "$JS_SCRIPT" || true
fi

echo "✔ Minecraft Desktop HUD added to your desktop!"
