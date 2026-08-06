import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "./modules"
import "./themes" as Theme

ShellRoot {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }
            implicitHeight: 30
            color: Theme.Main.background

            // Left zone
            RowLayout {
                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                    leftMargin: 18
                }
                spacing: 0   // or whatever you prefer

                Workspaces {}
            }

            // Center zone – always true horizontal center
            Clock {
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }
            }

            // Right zone
            RowLayout {
                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    rightMargin: 18
                }
                spacing: 15
                Bluetooth {}
                Network {}
                Volume {}
                Battery {}
            }
        }
    }
}