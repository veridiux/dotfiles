import Quickshell
import QtQuick
import "./modules"
import "./themes" as Theme

// ==========================================
// ROOT
// ==========================================

// The root object of our Quickshell configuration.
ShellRoot {

    // ==========================================
    // DROPDOWN STATE
    // ==========================================

    // Controls whether the dropdown should be visible.
    //
    // false = closed
    // true  = open
    property bool dropdownOpen: false

    // Keeps track of whether the mouse is
    // currently over the dropdown.
    property bool dropdownHovered: false

    // Keeps track of whether the mouse is
    // currently over the button.
    property bool buttonHovered: false


    // ==========================================
    // BUTTON WINDOW
    // ==========================================

    // The main window containing our button.
    PanelWindow {

        // Give this window an ID so other objects
        // can refer to it.
        id: buttonWindow

        // Width of the button window.
        implicitWidth: 300

        // Height of the button window.
        implicitHeight: 50


        // ------------------------------------------
        // BUTTON BACKGROUND
        // ------------------------------------------

        // Rectangle provides the visible background
        // of our button.
        Rectangle {
            anchors.fill: parent

            // Button background color.
            color: "#222222"


            // ------------------------------------------
            // BUTTON TEXT
            // ------------------------------------------

            // Text displayed in the center of the button.
            Text {
                anchors.centerIn: parent

                text: "Hover me"
                color: "white"
            }


            // ------------------------------------------
            // BUTTON MOUSE AREA
            // ------------------------------------------

            // MouseArea allows us to detect mouse
            // movement over the button.
            MouseArea {
                anchors.fill: parent

                // Without this, onEntered and onExited
                // will not detect normal mouse hovering.
                hoverEnabled: true


                // Runs when the mouse enters the button.
                onEntered: {

                    // Remember that the mouse is
                    // currently over the button.
                    buttonHovered = true

                    // Open the dropdown.
                    dropdownOpen = true

                    console.log("Mouse entered button")
                }


                // Runs when the mouse leaves the button.
                onExited: {

                    // Remember that the mouse is
                    // no longer over the button.
                    buttonHovered = false

                    // We don't close the dropdown here.
                    //
                    // The mouse may be moving from the
                    // button into the dropdown.
                    console.log("Mouse exited button")
                }
            }
        }
    }


    // ==========================================
    // DROPDOWN WINDOW
    // ==========================================

    // PopupWindow creates a separate floating window
    // for our dropdown.
    PopupWindow {

        // Attach this popup to our button window.
        //
        // This gives Quickshell a reference point
        // for positioning the popup.
        anchor.window: buttonWindow
        color: "transparent"

        // ------------------------------------------
        // DROPDOWN POSITION
        // ------------------------------------------

        // Align the left side of the dropdown
        // with the left side of the button.
        anchor.rect.x: 0

        // Position the dropdown below the button.
        //
        // buttonWindow.height is the height of
        // our button.
        //
        // +10 adds a 10 pixel gap.
        anchor.rect.y: buttonWindow.height + 10


        // Only show the PopupWindow while
        // dropdownOpen is true.
        visible: dropdownOpen


        // Width of the dropdown window.
        implicitWidth: 300

        // Height available to the dropdown.
        implicitHeight: 150


        // ------------------------------------------
        // DROPDOWN BACKGROUND
        // ------------------------------------------

        // Rectangle provides the visible appearance
        // of our dropdown.
        Rectangle {
            id: dropdownBackground
            
            Network {
              //  anchors.centerIn: parent
              //  width: 250
              //  height: 40
            }

            // Keep the rectangle attached to the
            // top of the PopupWindow.
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top


            // ------------------------------------------
            // DROPDOWN ANIMATION
            // ------------------------------------------

            // When closed, the height is 0.
            //
            // When open, the height becomes 150.
            //
            // Because the top stays anchored, the
            // dropdown grows downward.
            height: dropdownOpen ? 150 : 0


            // Animate changes to the height.
            Behavior on height {

                NumberAnimation {

                    // Duration of the animation in
                    // milliseconds.
                    duration: 400
                }
            }


            // ------------------------------------------
            // DROPDOWN APPEARANCE
            // ------------------------------------------

            // Mostly transparent black background.
            //
            // The last value controls transparency:
            //
            // 0.0 = completely transparent
            // 1.0 = completely opaque
            color: Qt.rgba(0, 0, 0, 0.50)


            // Round the corners of the dropdown.
            // Top corners are square.
            // Bottom corners are rounded.
            topLeftRadius: 0
            topRightRadius: 0
            bottomLeftRadius: 12
            bottomRightRadius: 12


            // Add a thin border around the dropdown.
            border.width: 1

            // Make the border slightly transparent.
            border.color: Qt.rgba(255, 255, 255, 0.12)


            // ------------------------------------------
            // DROPDOWN MOUSE AREA
            // ------------------------------------------

            // Detect mouse movement over the dropdown.
            MouseArea {
                anchors.fill: parent

                // Enable hover detection.
                hoverEnabled: true


                // Runs when the mouse enters
                // the dropdown.
                onEntered: {

                    // Remember that the mouse is
                    // currently over the dropdown.
                    dropdownHovered = true

                    console.log("Mouse entered dropdown")
                }


                // Runs when the mouse leaves
                // the dropdown.
                onExited: {

                    // Remember that the mouse is
                    // no longer over the dropdown.
                    dropdownHovered = false


                    // Only close the dropdown if the
                    // mouse isn't over the button either.
                    //
                    // This allows the user to move from
                    // the button into the dropdown.
                    if (!buttonHovered) {
                        dropdownOpen = false
                    }

                    console.log("Mouse exited dropdown")
                }
            }
        }
    }
}
