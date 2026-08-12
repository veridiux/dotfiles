import Quickshell
import Quickshell.Io
import QtQuick
import "../themes" as Theme


// ==========================================================
// CLOCK COMPONENT
// ==========================================================

// This Item is the Clock component.
//
// When shell.qml writes:
//
//     Clock {}
//
// Quickshell loads this file and creates this Item.
Item {

    id: clockItem


    // ======================================================
    // CONNECTION TO THE MAIN PANEL
    // ======================================================

    // shell.qml gives us the main PanelWindow:
//
//     Clock {
//         panelWindow: mainPanel
//     }
//
// This property stores that reference.
//
// It allows this Clock component to know about
// the PanelWindow that contains it.
property var panelWindow


    // ======================================================
    // CLOCK STATE
    // ======================================================

    // Swap between military time and save between restarts
    property bool militaryTime: false

    FileView {
        id: clockSettings

        path: Quickshell.statePath("clock-settings")

        blockLoading: true

        onLoaded: {
            if (text() === "true") {
                militaryTime = true
            } else {
                militaryTime = false
            }
        }
    }

    // True while the mouse is over the clock.
    property bool hovered: false

    // True while the mouse is over the dropdown.
    property bool dropdownHovered: false

    // Controls whether the dropdown is open.
    property bool dropdownOpen: false


    // Size of the Clock component.
    implicitWidth: 350
    implicitHeight: 35


    // ======================================================
    // CLOCK TEXT
    // ======================================================

    Row {
    anchors.centerIn: parent
    spacing: 0

        Text {
            text: "// "
            color: Theme.Main.textSecondary

            font {
                family: "JetBrainsMono Nerd Font"
                letterSpacing: 5
                pixelSize: 15
                weight: 600
            }
        }

        Text {
            text: Qt.formatDateTime(
                clock.date,
                militaryTime
                    ? "dddd, MMM d "
                    : "dddd, MMM d "
            )

            color: Theme.Main.text

            font {
                family: "JetBrainsMono Nerd Font"
                letterSpacing: 5
                pixelSize: 15
                weight: 600
            }
        }

        Text {
            text: "|"
            color: Theme.Main.textSecondary

            font {
                family: "JetBrainsMono Nerd Font"
                letterSpacing: 5
                pixelSize: 15
                weight: 600
            }
        }

        Text {
            text: Qt.formatDateTime(
                clock.date,
                militaryTime
                    ? " HH:mm"
                    : " hh:mm AP"
            )

        Text {
            text: ""
            color: Theme.Main.textSecondary

            font {
                family: "JetBrainsMono Nerd Font"
                letterSpacing: 5
                pixelSize: 15
                weight: 600
            }
        
        }

            color: Theme.Main.text

            font {
                family: "JetBrainsMono Nerd Font"
                letterSpacing: 5
                pixelSize: 15
                weight: 600
            }
        }

        Text {
            text: " //"
            color: Theme.Main.textSecondary

            font {
                family: "JetBrainsMono Nerd Font"
                letterSpacing: 5
                pixelSize: 15
                weight: 600
            }
        }
    }



    // ======================================================
    // SYSTEM CLOCK
    // ======================================================

    // Provides the current date and time.
    SystemClock {
        id: clock

        precision: SystemClock.Minutes
    }


    // ======================================================
    // CLOCK MOUSE AREA
    // ======================================================

    // This MouseArea sits on top of the Clock
    // and detects when the mouse enters or leaves it.
    MouseArea {
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        anchors.fill: parent
        hoverEnabled: true


        // Mouse entered the Clock.
        onEntered: {
            hovered = true
            dropdownOpen = true

            console.log("Mouse entered clock")
        }


        // Mouse left the Clock.
        onExited: {
            hovered = false

            console.log("Mouse left clock")
        }

        onClicked: {
            if (mouse.button === Qt.RightButton){
                militaryTime = !militaryTime

                clockSettings.setText(
                    militaryTime ? "true" : "false"
                )
            }

            if (mouse.button === Qt.LeftButton){
                dropdownOpen = false
            }

            console.log("Military time:", militaryTime)
        }
    }


    // ======================================================
    // DROPDOWN
    // ======================================================

    // PopupWindow is a separate floating window.
    //
    // It is NOT a child inside the visual PanelWindow.
    // Instead, we tell it which window it should use
    // as its anchor.
    PopupWindow {

        // Use the main panel as the coordinate system
        // for positioning the dropdown.
        //
        // panelWindow came from shell.qml.
        anchor.window: panelWindow

        color: "transparent"


        // ==================================================
        // DROPDOWN POSITION
        // ==================================================

        // The Clock is centered inside the main panel.
        //
        // Calculate the Clock's left position:
        //
        //     panel width - clock width
        //     --------------------------------
        //                    2
        //
        // This puts the dropdown in the center underneath the Clock.
        anchor.rect.x:
            (panelWindow.width - implicitWidth) / 2


        // Put the dropdown below the panel.
        //
        // panelWindow.height = height of the top bar.
        //
        // +30 = the gap between the bar and dropdown.
        anchor.rect.y:
            panelWindow.height + 5


        // Only show the popup while dropdownOpen is true.
        visible: dropdownOpen


        // Size of the popup.
        implicitWidth: 800
        implicitHeight: 300


        // ==================================================
        // DROPDOWN BACKGROUND
        // ==================================================

        Rectangle {
            id: dropdownBackground

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top


            // ==================================================
            // DROPDOWN ANIMATION
            // ==================================================

            // Closed = height 0.
            //
            // Open = height 150.
            //
            // Because the top stays in the same place,
            // the dropdown appears to grow downward.
            height: dropdownOpen ? 150 : 0

            Behavior on height {
                NumberAnimation {
                    duration: 400
                }
            }


            // ==================================================
            // DROPDOWN APPEARANCE
            // ==================================================

            // Semi-transparent black background.
            color: Qt.rgba(0, 0, 0, 0.50)

            // Square top corners.
            topLeftRadius: 0
            topRightRadius: 0

            // Rounded bottom corners.
            bottomLeftRadius: 12
            bottomRightRadius: 12

            // Thin border.
            border.width: 1
            border.color: Qt.rgba(255, 255, 255, 0.12)


            // ==================================================
            // DROPDOWN MOUSE AREA
            // ==================================================

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true


                // Mouse entered the dropdown.
                onEntered: {
                    dropdownHovered = true

                    console.log("Mouse entered dropdown")
                }


                // Mouse left the dropdown.
                onExited: {
                    dropdownHovered = false


                    // Only close the dropdown if the mouse
                    // isn't still over the Clock.
                    if (!hovered) {
                        dropdownOpen = false
                    }

                    console.log("Mouse exited dropdown")
                }
            }
        }
    }
}