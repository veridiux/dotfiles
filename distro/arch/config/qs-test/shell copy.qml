import Quickshell   // Container
import Quickshell.Hyprland // Import hyprland
import QtQuick  // Import Text
import QtQuick.Layouts // Lets us determine where something is in a row

ShellRoot {
    Variants {
        model: Quickshell.screens   // List of your monitors

        PanelWindow {   // Decorationless Window bound to the screen by anchors
            required property var modelData
            screen: modelData

            anchors{
                top: true
                left: true
                right: true
            }
            implicitHeight: 30
            color: "#040e0d"

            RowLayout { // Children go from left to right
                anchors.fill: parent
                anchors.leftMargin: 18
                anchors.rightMargin: 18
                
                Workspaces {}
                Item { Layout.fillWidth: true }
                Clock {}
                Item { Layout.fillWidth: true }

                RowLayout{
                    spacing: 15
                    Network {}
                    Volume {}
                    Battery {}
                }
            }
        }
    }
}