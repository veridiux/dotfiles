import Quickshell
import QtQuick

// The root object of our Quickshell configuration.
ShellRoot {

    // Keeps track of whether the dropdown is open.
    //
    // false = closed
    // true  = open
    property bool dropdownOpen: false


    // Our main button window.
    PanelWindow {

        // Give this window a name so other objects
        // can refer to it.
        id: buttonWindow

        // Requested width of the button.
        implicitWidth: 300

        // Requested height of the button.
        implicitHeight: 50


        // The visible background of the button.
        Rectangle {
            anchors.fill: parent

            color: "#222222"


            // Text displayed inside the button.
            Text {
                anchors.centerIn: parent

                text: "Click me"
                color: "white"
            }


            // Detects mouse clicks.
            MouseArea {
                anchors.fill: parent

                // Runs when the button is clicked.
                onClicked: {

                    // Toggle the dropdown state.
                    //
                    // false → true
                    // true  → false
                    dropdownOpen = !dropdownOpen

                    // Print the current state to the terminal.
                    console.log("Dropdown:", dropdownOpen)
                }
            }
        }
    }


    // Our floating dropdown.
    PopupWindow {

        // Tell Quickshell that this popup is attached
        // to our buttonWindow.
        //
        // This gives the popup a reference point for positioning.
        anchor.window: buttonWindow

        // Show the popup when dropdownOpen is true.
        visible: dropdownOpen

        // Requested width of the dropdown.
        implicitWidth: 200

        // Requested height of the dropdown.
        implicitHeight: 150


        // The visual contents of the dropdown.
        Rectangle {
            anchors.fill: parent

            color: "#333333"
            radius: 10
        }
    }
}
