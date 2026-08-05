import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

RowLayout {
    spacing :6

    Repeater {
        model: 9

        Rectangle {
            id: wsButton
            required property int index

            property var ws: Hyprland.workspaces.values.find(w => w.id === index +1)
            property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

            implicitWidth: label.implicitWidth + 14
            implicitHeight: 22
            radius: 6

            color: isActive ? '#1d3631' : (ws ? '#0f211f' : "transparent")

            Behavior on color {
                ColorAnimation { duration: 150 }
            }

            Text {
                id: label
                anchors.centerIn: parent
                text: wsButton.index + 1
                color: wsButton.isActive ? '#3dd1b0' : (wsButton.ws ? '#f5e2c5' : "#5a4d3e")

                font {
                    family: "JetBraingsMono Nerd Font"
                    pixelSize: 14
                    weight: 500
                }
            }

            MouseArea {  // Cickable area
                anchors.fill: parent // Fills entire area with clickable
                onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + (parent.index + 1) + "})")
            }
        }
    }
}