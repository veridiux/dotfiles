import Quickshell
import QtQuick
import "../widgets/"
import "../theme/"
import "../services/"

PanelWindow {
    HyprlandService {
        id: hyprland
    }
    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 36

    Rectangle {
        anchors.fill: parent
        color: Colors.background

        Item {
            anchors.fill: parent

            // LEFT
            Workspaces {
                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }

                activeWorkspace: hyprland.focusedWorkspace?.id ?? 1
                workspaces: hyprland.workspaces
            }


            // CENTER
            Clock {
                anchors.centerIn: parent
            }


            // RIGHT
            Status {
                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}