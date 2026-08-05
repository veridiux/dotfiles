import Quickshell
import QtQuick

Text {
    text: Qt.formatDateTime(clock.date, "hh:mm")
    color: "#f5e2c5"

    font {
        family: "JetBrainsMono Nerd Font"
        letterSpacing: -1
        pixelSize: 15
        weight: 600
    }
    SystemClock {
        id: clock   // id = reference to recognize
        precision: SytemClock.Minutes
    }
}