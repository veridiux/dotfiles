import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

Repeater {
    model: SystemTray.items

    MouseArea {
        id: trayItem
        required property var modelData

        implicitWidth: 24
        implicitHeight: 24
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

        Image {
            anchors.centerIn: parent
            width: 18
            height: 18
            source: modelData.icon
            sourceSize: Qt.size(18, 18)
            smooth: true
        }

        onClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton) {
                if (!modelData.onlyMenu)
                    modelData.activate()          // bring window back / primary action
                else if (modelData.hasMenu)
                    trayMenu.open()
            } else if (mouse.button === Qt.MiddleButton) {
                modelData.secondaryActivate()
            } else if (mouse.button === Qt.RightButton && modelData.hasMenu) {
                trayMenu.open()
            }
        }

        // optional scroll support
        onWheel: (wheel) => {
            modelData.scroll(wheel.angleDelta.y / 120, false)
        }

        QsMenuAnchor {
            id: trayMenu
            menu: modelData.menu                  // ← this is the important part
            anchor.item: trayItem
            // adjust these depending on whether your bar is top or bottom
            anchor.edges: Edges.Bottom
            anchor.gravity: Edges.Bottom
        }
    }
}
