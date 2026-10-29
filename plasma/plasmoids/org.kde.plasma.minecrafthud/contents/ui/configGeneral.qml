import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    id: page

    property alias cfg_showClock: showClockCheck.checked
    property alias cfg_showIndicators: showIndicatorsCheck.checked
    property alias cfg_showHotbar: showHotbarCheck.checked
    property alias cfg_hudScale: scaleSlider.value

    property alias cfg_slot1Cmd: slot1Field.text
    property alias cfg_slot2Cmd: slot2Field.text
    property alias cfg_slot3Cmd: slot3Field.text
    property alias cfg_slot4Cmd: slot4Field.text
    property alias cfg_slot5Cmd: slot5Field.text
    property alias cfg_slot6Cmd: slot6Field.text
    property alias cfg_slot7Cmd: slot7Field.text
    property alias cfg_slot8Cmd: slot8Field.text
    property alias cfg_slot9Cmd: slot9Field.text

    CheckBox {
        id: showClockCheck
        Kirigami.FormData.label: "Components:"
        text: "Show Day/Night Clock"
    }

    CheckBox {
        id: showIndicatorsCheck
        text: "Show Health / Hunger / XP Indicators"
    }

    CheckBox {
        id: showHotbarCheck
        text: "Show Hotbar App Launcher"
    }

    Slider {
        id: scaleSlider
        Kirigami.FormData.label: "Scale Factor:"
        from: 0.5
        to: 2.0
        stepSize: 0.1
    }

    Label {
        text: Math.round(scaleSlider.value * 100) + "%"
    }

    Item {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: "Hotbar Slot Commands"
    }

    TextField {
        id: slot1Field
        Kirigami.FormData.label: "Slot 1 (Sword):"
        placeholderText: "konsole"
    }

    TextField {
        id: slot2Field
        Kirigami.FormData.label: "Slot 2 (Compass):"
        placeholderText: "kde-open https://google.com"
    }

    TextField {
        id: slot3Field
        Kirigami.FormData.label: "Slot 3 (Chest):"
        placeholderText: "dolphin"
    }

    TextField {
        id: slot4Field
        Kirigami.FormData.label: "Slot 4 (Book):"
        placeholderText: "kate"
    }

    TextField {
        id: slot5Field
        Kirigami.FormData.label: "Slot 5 (Crafting Table):"
        placeholderText: "systemsettings"
    }

    TextField {
        id: slot6Field
        Kirigami.FormData.label: "Slot 6 (TNT):"
        placeholderText: "plasma-systemmonitor"
    }

    TextField {
        id: slot7Field
        Kirigami.FormData.label: "Slot 7 (Jukebox):"
        placeholderText: "elisa"
    }

    TextField {
        id: slot8Field
        Kirigami.FormData.label: "Slot 8 (Emerald):"
        placeholderText: "discover"
    }

    TextField {
        id: slot9Field
        Kirigami.FormData.label: "Slot 9 (Lava Bucket):"
        placeholderText: "dolphin trash:/"
    }
}
