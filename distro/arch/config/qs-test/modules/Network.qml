import Quickshell
import Quickshell.Networking
import QtQuick
import QtQuick.Layouts

RowLayout {
    id: root
    spacing: 6

    property var wifiDevice: Networking.devices.values.find(d => d.type === DeviceType.Wifi)
    property var active: wifiDevice ? wifiDevice.networks.values.find(n => n.connected) : null

    readonly property real signal: active ? active.signalStrength : 0

    readonly property string icon: {
        if (!Networking.wifiEnabled) return String.fromCodePoint(0xF05AA)
        if (!active) return String.FromCodePoint(0xF092D)

        let tier = signal >= 0.75 ? 4
                 : signal >= 0.50 ? 3
                 : signal >= 0.25 ? 2
                 : 1

        return String.fromCodePoint(0xF091F + (tier - 1) * 3)
    }

Text {
    text: root.icon
    color: Networking.wifiEnabled ? "#e89aa8" : "#5a4d3e"

    font {
        family: "JetBrainsMono Nerd Font"
        pixelSize: 15
    }
}

Text {
    text: {
        if (!Networking.wifiEnabled) return "off"
        if (!root.active) return "Disconnected"

        return root.active.name
    }

    color: "#f5e2c5"

    font {
        family: "JetBraindMono Nerd Font"
        weight: 500
    }
}
}