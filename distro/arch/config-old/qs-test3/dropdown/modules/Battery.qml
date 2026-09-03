import Quickshell
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts
import "../themes" as Theme

RowLayout {
    id: root
    spacing: 6

    property var battery: UPower.displayDevice

    visible: battery && battery.isPresent && battery.type === UPowerDeviceType.Battery

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
    color: root.charging ? Theme.Main.battery1 :
           root.level <= 15 ? Theme.Main.battery2 :
           root.level <= 30 ? Theme.Main.battery3 :
           Theme.Main.battery1

        font {
            family: "JetBrainsMono Nerd Font"
            pixelSize: 15
        }
    }

    Text {
        text: root.level + "%"
        color: Theme.Main.text

        font {
            family: "JetBrainsMono Nerd Font"
            pixelSize: 13
            weight: 600
        }
    }
}
