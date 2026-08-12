//@ pragma UseQApplication

import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "./modules"
import "./themes" as Theme


ShellRoot {

    // Creates one copy of the panel for each monitor.
    Variants {
        model: Quickshell.screens


        // ==================================================
        // MAIN PANEL
        // ==================================================

        // This is the actual top bar.
        //
        // Everything inside this PanelWindow is a child
        // of the panel.
        PanelWindow {

            // Give the panel a name so other objects
            // can refer to this specific PanelWindow.
            id: mainPanel

            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 30

            color: Theme.Main.background


            // ==================================================
            // LEFT SIDE
            // ==================================================

            RowLayout {
                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                    leftMargin: 18
                }

                spacing: 0

                Workspaces {}
            }


            // ==================================================
            // CENTER CLOCK
            // ==================================================

            // Clock is a separate component defined in
            // modules/Clock.qml.
            //
            // panelWindow: mainPanel
            //
            // gives Clock.qml a reference to this PanelWindow.
            Clock {
                panelWindow: mainPanel

                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }
            }


            // ==================================================
            // RIGHT SIDE
            // ==================================================

            RowLayout {
                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    rightMargin: 18
                }

                spacing: 15

                Tray {}
                Bluetooth {}
                Network {}
                Volume {}
                Battery {}
                Power {}
            }
        }
    }
}