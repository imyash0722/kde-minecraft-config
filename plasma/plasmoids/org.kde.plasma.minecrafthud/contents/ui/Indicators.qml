import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
    id: root

    property font mcFont
    property real healthPercent: 1.0 // 0.0 to 1.0
    property real hungerPercent: 1.0 // 0.0 to 1.0
    property real armorPercent: 1.0  // 0.0 to 1.0
    property int xpLevel: 30
    property real xpPercent: 0.75

    readonly property real barHeight: 16
    readonly property real barWidth: 162
    readonly property real expWidth: 366
    readonly property real expHeight: 10

    implicitWidth: expWidth
    implicitHeight: mainCol.implicitHeight

    ColumnLayout {
        id: mainCol
        anchors.centerIn: parent
        spacing: 4

        // Top: Armor bar (above health)
        RowLayout {
            Layout.alignment: Qt.AlignLeft
            Item {
                width: root.barWidth
                height: root.barHeight

                // Empty background
                Image {
                    anchors.fill: parent
                    source: "../images/armor_empty.png"
                    smooth: false
                    fillMode: Image.Stretch
                }

                // Filled portion with clip
                Item {
                    width: parent.width * Math.max(0, Math.min(1, root.armorPercent))
                    height: parent.height
                    clip: true

                    Image {
                        width: root.barWidth
                        height: root.barHeight
                        source: "../images/armor_fill.png"
                        smooth: false
                        fillMode: Image.Stretch
                    }
                }

                ToolTip.visible: armorMouse.containsMouse
                ToolTip.text: "Armor / Swap: " + Math.round(root.armorPercent * 100) + "%"

                MouseArea {
                    id: armorMouse
                    anchors.fill: parent
                    hoverEnabled: true
                }
            }
        }

        // Middle row: Health Hearts (Left) & Hunger Drumsticks (Right)
        RowLayout {
            spacing: 42
            Layout.alignment: Qt.AlignHCenter

            // Health (Hearts)
            Item {
                width: root.barWidth
                height: root.barHeight

                Image {
                    anchors.fill: parent
                    source: "../images/heart_empty.png"
                    smooth: false
                    fillMode: Image.Stretch
                }

                Item {
                    width: parent.width * Math.max(0, Math.min(1, root.healthPercent))
                    height: parent.height
                    clip: true

                    Image {
                        width: root.barWidth
                        height: root.barHeight
                        source: "../images/heart_fill.png"
                        smooth: false
                        fillMode: Image.Stretch
                    }
                }

                ToolTip.visible: healthMouse.containsMouse
                ToolTip.text: "Health / CPU: " + Math.round(root.healthPercent * 100) + "%"

                MouseArea {
                    id: healthMouse
                    anchors.fill: parent
                    hoverEnabled: true
                }
            }

            // Hunger (Food)
            Item {
                width: root.barWidth
                height: root.barHeight

                Image {
                    anchors.fill: parent
                    source: "../images/food_empty.png"
                    smooth: false
                    fillMode: Image.Stretch
                }

                Item {
                    anchors.right: parent.right
                    width: parent.width * Math.max(0, Math.min(1, root.hungerPercent))
                    height: parent.height
                    clip: true

                    Image {
                        anchors.right: parent.right
                        width: root.barWidth
                        height: root.barHeight
                        source: "../images/food_fill.png"
                        smooth: false
                        fillMode: Image.Stretch
                    }
                }

                ToolTip.visible: foodMouse.containsMouse
                ToolTip.text: "Hunger / RAM: " + Math.round(root.hungerPercent * 100) + "%"

                MouseArea {
                    id: foodMouse
                    anchors.fill: parent
                    hoverEnabled: true
                }
            }
        }

        // Bottom row: XP level & XP bar
        Item {
            Layout.alignment: Qt.AlignHCenter
            width: root.expWidth
            height: root.expHeight + 14

            // Glowing XP Level number
            Text {
                id: xpText
                text: root.xpLevel.toString()
                color: "#55FF55"
                font.family: root.mcFont ? root.mcFont.family : "Monospace"
                font.pixelSize: 14
                font.bold: true
                style: Text.Outline
                styleColor: "#000000"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: -4
                z: 2
            }

            // XP bar background
            Image {
                anchors.bottom: parent.bottom
                width: root.expWidth
                height: root.expHeight
                source: "../images/exp_empty.png"
                smooth: false
                fillMode: Image.Stretch
            }

            // XP bar fill
            Item {
                anchors.bottom: parent.bottom
                width: root.expWidth * Math.max(0, Math.min(1, root.xpPercent))
                height: root.expHeight
                clip: true

                Image {
                    width: root.expWidth
                    height: root.expHeight
                    source: "../images/exp_fill.png"
                    smooth: false
                    fillMode: Image.Stretch
                }
            }

            ToolTip.visible: xpMouse.containsMouse
            ToolTip.text: "Level: " + root.xpLevel + " (" + Math.round(root.xpPercent * 100) + "%)"

            MouseArea {
                id: xpMouse
                anchors.fill: parent
                hoverEnabled: true
            }
        }
    }
}
