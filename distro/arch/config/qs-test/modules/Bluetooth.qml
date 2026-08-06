import Quickshell
import Quickshell.Bluetooth
import QtQuick
import QtQuick.Layouts
import "../themes" as Theme

RowLayout {
    id: root
    spacing: 6

    // Default adapter (usually the only one)
    property var adapter: Bluetooth.defaultAdapter

    // All connected devices across adapters
    // (or use adapter.devices if you only care about one adapter)
    readonly property var connectedDevices: {
        if (!adapter || !adapter.devices)
            return []
        return Array.from(adapter.devices.values).filter(d => d.connected)
    }

    readonly property var active: connectedDevices.length > 0 ? connectedDevices[0] : null

    readonly property string icon: {
        // Adapter missing or powered off
        if (!adapter || !adapter.enabled)
            return String.fromCodePoint(0xF00B2)   // md-bluetooth_off  󰂲

        // Powered on + at least one device connected
        if (active)
            return String.fromCodePoint(0xF00B1)   // md-bluetooth_connect  󰂱

        // Powered on but nothing connected
        return String.fromCodePoint(0xF00AF)       // md-bluetooth  󰂯
    }

    Text {
        text: root.icon
        color: (adapter && adapter.enabled) ? Theme.Main.textSecondary : "#5a4d3e"

        font {
            family: "JetBrainsMono Nerd Font"
            pixelSize: 15
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                Quickshell.execDetached(["blueberry"])
        }
}
    }

    Text {
        text: {
            if (!adapter || !adapter.enabled)
                return "off"

            if (!root.active)
                return "Disconnected"          // or just "On"

            // Show first connected device name
            // (device.name is the alias if set, otherwise the device-provided name)
            return root.active.name || root.active.deviceName || "Connected"
        }

        color: '#f5e2c5'

        font {
            family: "JetBrainsMono Nerd Font"
            pixelSize: 13
            weight: 600
        }
    }
}