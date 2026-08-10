import Quickshell
import QtQuick
import "../themes" as Theme

Text {
    text: Qt.formatDateTime(clock.date, "dddd, MMM d | hh:mm")
    color: Theme.Main.text

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
