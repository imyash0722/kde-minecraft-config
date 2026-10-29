import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
    id: root

    property font mcFont
    signal slotTriggered(int index, string command)

    // Slot configurations
    property var slots: [
        { name: "Terminal", icon: "../images/diamond_sword.png", cmd: "konsole" },
        { name: "Browser", icon: "../images/compass.png", cmd: "kde-open https://google.com" },
        { name: "Files", icon: "../images/chest.png", cmd: "dolphin" },
        { name: "Editor", icon: "../images/writable_book.png", cmd: "kate" },
        { name: "Settings", icon: "../images/crafting_table.png", cmd: "systemsettings" },
        { name: "Monitor", icon: "../images/tnt.png", cmd: "plasma-systemmonitor" },
        { name: "Audio", icon: "../images/jukebox.png", cmd: "elisa" },
        { name: "Software", icon: "../images/emerald.png", cmd: "discover" },
        { name: "Trash", icon: "../images/lava_bucket.png", cmd: "dolphin trash:/" }
    ]

    readonly property real hotbarWidth: 414
    readonly property real hotbarHeight: 46
    readonly property real slotSize: hotbarWidth / 9.0

    property int hoveredIndex: -1
    property int selectedIndex: 0

    implicitWidth: hotbarWidth
    implicitHeight: hotbarHeight + 8

    // Hotbar background texture
    Image {
        id: bg
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: root.hotbarWidth
        height: root.hotbarHeight
        source: "../images/hotbar9.png"
        smooth: false
        fillMode: Image.Stretch
    }

    // Interactive slots
    Row {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: root.hotbarWidth
        height: root.hotbarHeight

        Repeater {
            model: root.slots.length

            Item {
                width: root.slotSize
                height: root.hotbarHeight

                readonly property var slotData: root.slots[index]

                // Slot item icon
                Image {
                    anchors.centerIn: parent
                    width: 32
                    height: 32
                    source: slotData.icon
                    smooth: false
                    fillMode: Image.PreserveAspectFit
                }

                // Slot number (1-9) in authentic Minecraft font
                Text {
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.margins: 4
                    text: (index + 1).toString()
                    color: "#A0A0A0"
                    font.family: root.mcFont ? root.mcFont.family : "Monospace"
                    font.pixelSize: 10
                    style: Text.Outline
                    styleColor: "#1A1A1A"
                }

                // Slot highlight box on hover
                Image {
                    anchors.centerIn: parent
                    width: root.slotSize + 6
                    height: root.hotbarHeight + 6
                    source: "../images/slot-highlight.png"
                    smooth: false
                    visible: root.hoveredIndex === index || root.selectedIndex === index
                    fillMode: Image.Stretch
                }

                ToolTip.visible: slotMouse.containsMouse
                ToolTip.text: slotData.name + "\n(" + slotData.cmd + ")"

                MouseArea {
                    id: slotMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onEntered: {
                        root.hoveredIndex = index;
                    }
                    onExited: {
                        if (root.hoveredIndex === index) {
                            root.hoveredIndex = -1;
                        }
                    }
                    onClicked: {
                        root.selectedIndex = index;
                        root.slotTriggered(index, slotData.cmd);
                    }
                }
            }
        }
    }
}
