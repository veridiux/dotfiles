import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "../themes" as Theme

RowLayout {
    id: root

    spacing: 4


    // ============================================================
    // WORKSPACE SYSTEM LABEL
    // ============================================================

    Text {
        text: "WS"

        font {
            family: "JetBrainsMono Nerd Font"
            pixelSize: 8
            weight: Font.Bold
            letterSpacing: 1
        }

        color: Theme.Main.border

        opacity: 0.7

        Layout.alignment: Qt.AlignVCenter
    }


    // Small separator
    Rectangle {
        width: 1
        height: 12

        color: Theme.Main.border

        opacity: 0.25

        Layout.alignment: Qt.AlignVCenter
    }


    // ============================================================
    // WORKSPACES
    // ============================================================

    Repeater {
        model: 9

        Item {
            id: wsButton

            required property int index

            property var ws:
                Hyprland.workspaces.values.find(
                    w => w.id === index + 1
                )

            property bool isActive:
                Hyprland.focusedWorkspace?.id === (index + 1)

            property bool isOccupied:
                ws !== undefined && ws !== null

            property bool isHovered:
                mouse.containsMouse


            implicitWidth: isActive ? 38 : 30
            implicitHeight: 25


            Behavior on implicitWidth {
                NumberAnimation {
                    duration: 180
                    easing.type: Easing.OutCubic
                }
            }


            // ====================================================
            // BACKGROUND
            // ====================================================

            Rectangle {
                id: background

                anchors.fill: parent

                radius: 5

                color: {
                    if (wsButton.isActive)
                        return Qt.rgba(
                            Theme.Main.border.r,
                            Theme.Main.border.g,
                            Theme.Main.border.b,
                            0.14
                        )

                    if (wsButton.isHovered)
                        return Qt.rgba(
                            Theme.Main.border.r,
                            Theme.Main.border.g,
                            Theme.Main.border.b,
                            0.07
                        )

                    return "transparent"
                }

                border.width:
                    wsButton.isActive
                    ? 1
                    : (wsButton.isHovered ? 1 : 0)

                border.color: Qt.rgba(
                    Theme.Main.border.r,
                    Theme.Main.border.g,
                    Theme.Main.border.b,
                    wsButton.isActive ? 0.45 : 0.18
                )


                Behavior on color {
                    ColorAnimation {
                        duration: 140
                    }
                }

                Behavior on border.color {
                    ColorAnimation {
                        duration: 140
                    }
                }
            }


            // ====================================================
            // ACTIVE WORKSPACE ACCENT
            // ====================================================

            Rectangle {
                id: activeBar

                anchors.bottom: parent.bottom

                anchors.horizontalCenter: parent.horizontalCenter

                width: wsButton.isActive ? 18 : 0

                height: 2

                radius: 1

                color: Theme.Main.border

                opacity: wsButton.isActive ? 1 : 0


                Behavior on width {
                    NumberAnimation {
                        duration: 180
                        easing.type: Easing.OutCubic
                    }
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: 120
                    }
                }
            }


            // ====================================================
            // OCCUPIED STATUS DOT
            // ====================================================

            Rectangle {
                id: occupiedDot

                width: wsButton.isOccupied ? 3 : 0
                height: 3

                radius: 1.5

                anchors.top: parent.top
                anchors.right: parent.right

                anchors.topMargin: 3
                anchors.rightMargin: 4

                color: wsButton.isActive
                    ? Theme.Main.border
                    : Theme.Main.mainAccent

                opacity: wsButton.isOccupied ? 0.9 : 0


                Behavior on opacity {
                    NumberAnimation {
                        duration: 120
                    }
                }

                Behavior on width {
                    NumberAnimation {
                        duration: 120
                    }
                }
            }


            // ====================================================
            // WORKSPACE NUMBER
            // ====================================================

            Text {
                id: label

                anchors.centerIn: parent

                text: wsButton.index + 1

                color: {
                    if (wsButton.isActive)
                        return Theme.Main.border

                    if (wsButton.isOccupied)
                        return Theme.Main.text

                    return Theme.Main.mainAccent
                }

                opacity:
                    wsButton.isActive
                    ? 1
                    : (wsButton.isOccupied ? 0.85 : 0.38)


                font {
                    family: "JetBrainsMono Nerd Font"
                    pixelSize: wsButton.isActive ? 13 : 12
                    weight: wsButton.isActive
                        ? Font.Bold
                        : Font.Medium
                }


                Behavior on color {
                    ColorAnimation {
                        duration: 120
                    }
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: 120
                    }
                }

                Behavior on font.pixelSize {
                    NumberAnimation {
                        duration: 140
                    }
                }
            }


            // ====================================================
            // HOVER GLOW
            // ====================================================

            Rectangle {
                anchors.fill: parent

                anchors.margins: -2

                radius: 7

                color: "transparent"

                border.width: 1

                border.color: Theme.Main.border

                opacity:
                    wsButton.isHovered
                    ? 0.12
                    : 0

                z: -1


                Behavior on opacity {
                    NumberAnimation {
                        duration: 140
                    }
                }
            }


            // ====================================================
            // CLICK AREA
            // ====================================================

            MouseArea {
                id: mouse

                anchors.fill: parent

                hoverEnabled: true

                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    Hyprland.dispatch(
                        "hl.dsp.focus({ workspace = "
                        + (wsButton.index + 1)
                        + "})"
                    )
                }
            }
        }
    }
}