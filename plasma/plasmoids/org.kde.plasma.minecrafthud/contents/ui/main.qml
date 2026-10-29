import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import org.kde.plasma.plasma5support 2.0 as P5Support

PlasmoidItem {
    id: root

    preferredRepresentation: fullRepresentation
    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground

    FontLoader {
        id: mcFont
        source: "../../../../../fonts/Minecraft.otf"
    }

    // Config options
    readonly property bool cfgShowClock: Plasmoid.configuration.showClock ?? true
    readonly property bool cfgShowIndicators: Plasmoid.configuration.showIndicators ?? true
    readonly property bool cfgShowHotbar: Plasmoid.configuration.showHotbar ?? true
    readonly property real cfgScale: Plasmoid.configuration.hudScale ?? 1.0

    // System metrics
    property real currentCpu: 0.25
    property real currentMem: 0.40
    property real currentSwap: 0.10
    property int currentLevel: 30

    // Executable datasource to sample system stats and execute commands
    P5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []

        onNewData: function(sourceName, data) {
            var stdout = data.stdout ? data.stdout.trim() : "";
            disconnectSource(sourceName);
            if (stdout && sourceName.indexOf("stat") !== -1) {
                var lines = stdout.split("\n");
                if (lines.length >= 2) {
                    var cpu = parseFloat(lines[0]);
                    var mem = parseFloat(lines[1]);
                    if (!isNaN(cpu)) root.currentCpu = Math.max(0.05, Math.min(1.0, cpu / 100.0));
                    if (!isNaN(mem)) root.currentMem = Math.max(0.05, Math.min(1.0, mem / 100.0));
                }
            }
        }
    }

    Timer {
        id: statsTimer
        interval: 2500
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            var cmd = "awk '/cpu /{print 100*($2+$4)/($2+$4+$5)}' /proc/stat; awk '/MemTotal/{t=$2}/MemAvailable/{a=$2}END{print 100*(t-a)/t}' /proc/meminfo";
            executable.connectSource(cmd);
        }
    }

    function runCommand(cmd) {
        if (!cmd) return;
        executable.connectSource("kstart " + cmd);
    }

    fullRepresentation: Item {
        id: fullRep
        implicitWidth: hudContainer.implicitWidth * root.cfgScale
        implicitHeight: hudContainer.implicitHeight * root.cfgScale

        Item {
            id: hudContainer
            anchors.centerIn: parent
            scale: root.cfgScale
            transformOrigin: Item.Center

            implicitWidth: Math.max(
                root.cfgShowHotbar ? hotbar.implicitWidth : 0,
                root.cfgShowIndicators ? indicators.implicitWidth : 0,
                root.cfgShowClock ? clock.implicitWidth : 0
            ) + 20
            implicitHeight: hudColumn.implicitHeight + 20

            ColumnLayout {
                id: hudColumn
                anchors.centerIn: parent
                spacing: 12

                // Top: Clock Widget
                ClockWidget {
                    id: clock
                    visible: root.cfgShowClock
                    Layout.alignment: Qt.AlignHCenter
                    mcFont: mcFont.font
                }

                // Middle: Indicators (Hearts, Food, Armor, XP)
                Indicators {
                    id: indicators
                    visible: root.cfgShowIndicators
                    Layout.alignment: Qt.AlignHCenter
                    mcFont: mcFont.font
                    healthPercent: 1.0 - root.currentCpu // High health = low load
                    hungerPercent: 1.0 - root.currentMem // Full food = plenty of RAM
                    armorPercent: 0.8
                    xpLevel: root.currentLevel
                    xpPercent: 0.65
                }

                // Bottom: Hotbar App Launcher
                Hotbar {
                    id: hotbar
                    visible: root.cfgShowHotbar
                    Layout.alignment: Qt.AlignHCenter
                    mcFont: mcFont.font

                    onSlotTriggered: function(index, cmd) {
                        root.runCommand(cmd);
                    }
                }
            }
        }
    }
}
