import Quickshell
import QtQuick

// The root object of our Quickshell configuration.
ShellRoot {

    // Keeps track of whether the dropdown is open.
    //
    // false = closed
    // true  = open
    property bool dropdownOpen: false

    // Is the mouse currently over the dropdown?
    property bool dropdownHovered: false

    // Is the mouse over the button?
    property bool buttonHovered: false


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
                hoverEnabled: true

                // Runs when the button is clicked. onClicked, onEntered, onExited
                onEntered: {

                    buttonHovered = true

                    // Toggle the dropdown state.
                    //
                    // false → true
                    // true  → false
                    // dropdownOpen = !dropdownOpen
                    dropdownOpen = true
                    console.log("Mouse entered")
                    // Print the current state to the terminal.
                    //console.log("Dropdown:", dropdownOpen)
                }
                onExited: {
                    buttonHovered = false
                    // dropdownOpen = false
                    console.log("Mouse exited")
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

        // Tell Quickshell which part of that window to use
        // as the popup's anchor point.
        //
        // x: 0     = left edge of the button
        // y: 50    = 50 pixels down, which is the bottom
        //            of our 50px-tall button.
        // buttonWindow.height puts popup under button no matter the height
        // buttonWindow.height + # adds a margin
        anchor.rect.x: 0
        anchor.rect.y: buttonWindow.height + 50

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

            // Detect if the mouse is over dropdown area
            MouseArea {
                // Cover the entire dropdown.
                anchors.fill: parent

                //Enabled hover detection.
                hoverEnabled: true
                //Mouse entered the dropdown

                onEntered: {
                    dropdownHovered = true
                    console.log("Mouse entered dropdown")
                }

                //Mouse exited the dropdown
                onExited: {
                    dropdownHovered = false
                    

                    // Check if on button either
                    if (!buttonHovered) {
                        dropdownOpen = false
                    }
                    
                    console.log("Mouse exited dropdown")
                }
            }
        }
    }
}
