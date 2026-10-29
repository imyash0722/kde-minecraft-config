import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
    id: root

    property font mcFont

    implicitWidth: clockRow.implicitWidth
    implicitHeight: clockRow.implicitHeight

    property int currentSecondOfDay: 0
    property string timeString: "12:00"
    property string dateString: "Day 1"

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            var now = new Date();
            root.currentSecondOfDay = now.getHours() * 3600 + now.getMinutes() * 60 + now.getSeconds();
            var hours = now.getHours();
            var mins = now.getMinutes();
            root.timeString = (hours < 10 ? "0" : "") + hours + ":" + (mins < 10 ? "0" : "") + mins;
            
            var days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
            var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
            root.dateString = days[now.getDay()] + ", " + months[now.getMonth()] + " " + now.getDate();
        }
    }

    // Minecraft clock has 64 frames, 256x256 per frame, 5 frames per row.
    // Noon is in middle of day (12:00), midnight at 00:00.
    // In Minecraft, day starts around frame 0 at 06:00 sunrise.
    // Frame = Math.floor(((currentSecondOfDay + 21600) % 86400) / 86400 * 64)
    readonly property int frameIndex: Math.floor(((currentSecondOfDay + 21600) % 86400) / 86400 * 64)
    readonly property int col: frameIndex % 5
    readonly property int row: Math.floor(frameIndex / 5)

    readonly property real clockSize: 48

    RowLayout {
        id: clockRow
        anchors.centerIn: parent
        spacing: 10

        // Clock sprite container
        Item {
            width: root.clockSize
            height: root.clockSize
            clip: true

            Image {
                id: spriteSheet
                source: "../images/clockSpriteSheet.png"
                width: root.clockSize * 5
                height: (root.clockSize / 256) * 3328
                x: -root.col * root.clockSize
                y: -root.row * root.clockSize
                smooth: false
                fillMode: Image.Stretch
            }
        }

        // Digital clock text
        ColumnLayout {
            spacing: 2
            Layout.alignment: Qt.AlignVCenter

            Text {
                text: root.timeString
                color: "#FFFFFF"
                font.family: root.mcFont ? root.mcFont.family : "Monospace"
                font.pixelSize: 18
                font.bold: true
                style: Text.Outline
                styleColor: "#1A1A1A"
            }

            Text {
                text: root.dateString
                color: "#55FF55" // Minecraft XP green
                font.family: root.mcFont ? root.mcFont.family : "Monospace"
                font.pixelSize: 11
                style: Text.Outline
                styleColor: "#1A1A1A"
            }
        }
    }
}
