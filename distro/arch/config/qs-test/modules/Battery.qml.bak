import Quickshell
import Quickshell.Services.UPower // Services make Quickshell get information from system directly
import QtQuick
import QtQuick.Layouts
import "../themes" as Theme

RowLayout {
    id: root
    spacing: 6

    property var battery: UPower.displayDevice
    property bool charging: battery.state === UPowerDeviceState.Charging
    readonly property int level: Math.round(battery.percentage * 100)

    readonly property string icon: {
    if (charging)
        return String.fromCodePoint(0xF0E7)

    if (level >= 90)
        return String.fromCodePoint(0xF240) // full
    if (level >= 60)
        return String.fromCodePoint(0xF241) // 3/4
    if (level >= 40)
        return String.fromCodePoint(0xF242) // half
    if (level >= 15)
        return String.fromCodePoint(0xF243) // 1/4
    return String.fromCodePoint(0xF244)    // empty
}

    Text {
        text: root.icon
        color: root.charging ? "#7ad9a8" 
                             : root.level <= 15 ? "#ff5048" 
                             : root.level <= 30 ? "#ffa478" 
                             : "#7ad9a8"

        font {
            family: "JetBrainsMono Nerd Font"
            pixelSize: 15
        }
    }

    Text {
        text: root.level + "%"
        color: "#f5e2c5"

        font {
            family: "JetBrainsMono Nerd Font"
            pixelSize: 13
            weight: 600
        }
    }
}