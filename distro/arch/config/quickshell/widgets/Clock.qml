import QtQuick
import "../theme/"

Text {
    property color textColor: Colors.text
    property string format: "hh:mm:ss"

    color: textColor

    property string currentTime: Qt.formatDateTime(new Date(), format)

    text: currentTime

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            currentTime = Qt.formatDateTime(new Date(), format)
        }
    }
}