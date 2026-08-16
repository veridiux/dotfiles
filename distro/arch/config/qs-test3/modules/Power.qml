import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../themes" as Theme

Item {
    id: root

    width: 28
    height: 28

    property bool menuOpen: false

    onMenuOpenChanged: {
        console.log("menuOpen changed:", root.menuOpen)
    }


    // ============================================================
    // POWER BUTTON
    // ============================================================

    Rectangle {
        anchors.fill: parent

        color: "transparent"
        radius: 6

        Text {
            anchors.centerIn: parent

            text: "⏻"

            font.pixelSize: 20

            color: root.menuOpen
                ? Theme.Main.border
                : Theme.Main.textSecondary

            Behavior on color {
                ColorAnimation {
                    duration: 180
                }
            }
        }

        MouseArea {
            anchors.fill: parent

            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onClicked: {
                root.menuOpen = !root.menuOpen
            }
        }
    }


    // ============================================================
    // POWER MENU
    // ============================================================

    PopupWindow {
        id: popup

        visible: root.menuOpen

        width: 190
        height: 205

        color: Theme.Main.bgt

        Rectangle {
            anchors.fill: parent

            color: Theme.Main.bgt

            border.width: Theme.Main.borderWidth
            border.color: Theme.Main.borderColor

            radius: Theme.Main.borderRadius
        }

        grabFocus: false

        anchor.item: root
        anchor.rect.y: root.height + 14


        Item {
            anchors.fill: parent

            focus: true

            Component.onCompleted: {
                forceActiveFocus()
            }

            onVisibleChanged: {
                if (visible)
                    forceActiveFocus()
            }


            // ====================================================
            // ESCAPE TO CLOSE
            // ====================================================

            Keys.onPressed: function(event) {
                if (event.key === Qt.Key_Escape) {
                    root.menuOpen = false
                    event.accepted = true
                }
            }


            // ====================================================
            // HOVER DETECTION
            // ====================================================

            HoverHandler {
                id: popupHover

                onHoveredChanged: {
                    if (!hovered)
                        closeTimer.restart()
                    else
                        closeTimer.stop()
                }
            }

            Timer {
                id: closeTimer

                interval: 100

                onTriggered: {
                    if (!popupHover.hovered)
                        root.menuOpen = false
                }
            }


            // ====================================================
            // MAIN HUD PANEL
            // ====================================================

            Rectangle {
                id: panel

                anchors.fill: parent

                radius: 0

                color: Theme.Main.background

                opacity: 0.97

                


                // =================================================
                // OUTER GLOW
                // =================================================

                Rectangle {
                    anchors.fill: parent

                    anchors.margins: -3

                    radius: 11

                    color: "transparent"

                    border.width: 1

                    border.color: Qt.rgba(
                        Theme.Main.border.r,
                        Theme.Main.border.g,
                        Theme.Main.border.b,
                        0.12
                    )

                    z: -1
                }


                // =================================================
                // TOP ACCENT BAR
                // =================================================

                Rectangle {
                    x: 14
                    y: 0

                    width: parent.width - 28
                    height: 2

                    radius: 1

                    color: Theme.Main.border

                    opacity: 0.85
                }


                // =================================================
                // HUD CORNERS
                // =================================================

                // Top left
                Rectangle {
                    x: 0
                    y: 9

                    width: 7
                    height: 1

                    color: Theme.Main.border
                }

                Rectangle {
                    x: 0
                    y: 9

                    width: 1
                    height: 7

                    color: Theme.Main.border
                }


                // Top right
                Rectangle {
                    x: parent.width - 7
                    y: 9

                    width: 7
                    height: 1

                    color: Theme.Main.border
                }

                Rectangle {
                    x: parent.width - 1
                    y: 9

                    width: 1
                    height: 7

                    color: Theme.Main.border
                }


                // Bottom left
                Rectangle {
                    x: 0
                    y: parent.height - 10

                    width: 7
                    height: 1

                    color: Theme.Main.border
                }

                Rectangle {
                    x: 0
                    y: parent.height - 16

                    width: 1
                    height: 7

                    color: Theme.Main.border
                }


                // Bottom right
                Rectangle {
                    x: parent.width - 7
                    y: parent.height - 10

                    width: 7
                    height: 1

                    color: Theme.Main.border
                }

                Rectangle {
                    x: parent.width - 1
                    y: parent.height - 16

                    width: 1
                    height: 7

                    color: Theme.Main.border
                }


                // =================================================
                // HEADER
                // =================================================

                Row {
                    x: 15
                    y: 12

                    spacing: 7

                    Text {
                        text: "POWER"

                        font.pixelSize: 11
                        font.weight: Font.Bold
                        font.letterSpacing: 2

                        color: Theme.Main.text
                    }

                    Text {
                        text: "//"

                        font.pixelSize: 10
                        font.weight: Font.Bold

                        color: Theme.Main.textSecondary
                    }

                    Text {
                        text: "CONTROL"

                        font.pixelSize: 9
                        font.letterSpacing: 1

                        color: Theme.Main.text
                    }
                }


                // =================================================
                // STATUS LIGHT
                // =================================================

                Rectangle {
                    x: parent.width - 25
                    y: 15

                    width: 5
                    height: 5

                    radius: 2.5

                    color: Theme.Main.border

                    opacity: 0.8
                }


                // =================================================
                // HEADER DIVIDER
                // =================================================

                Rectangle {
                    x: 14
                    y: 34

                    width: parent.width - 28
                    height: 1

                    color: Qt.rgba(
                        Theme.Main.border.r,
                        Theme.Main.border.g,
                        Theme.Main.border.b,
                        0.20
                    )
                }


                // =================================================
                // SHUTDOWN
                // =================================================

                Item {
                    id: shutdownButton

                    x: 15
                    y: 43

                    width: parent.width - 30
                    height: 43

                    Rectangle {
                        anchors.fill: parent

                        radius: 5

                        color: shutdownMouse.containsMouse
                            ? Qt.rgba(
                                Theme.Main.border.r,
                                Theme.Main.border.g,
                                Theme.Main.border.b,
                                0.09
                            )
                            : "transparent"

                        border.width: shutdownMouse.containsMouse ? 1 : 0

                        border.color: Qt.rgba(
                            Theme.Main.border.r,
                            Theme.Main.border.g,
                            Theme.Main.border.b,
                            0.30
                        )

                        Behavior on color {
                            ColorAnimation {
                                duration: 120
                            }
                        }
                    }


                    Rectangle {
                        x: 3
                        y: 9

                        width: 2
                        height: 25

                        radius: 1

                        color: Theme.Main.textSecondary

                        opacity: shutdownMouse.containsMouse
                            ? 1
                            : 0.25
                    }


                    Text {
                        x: 13
                        y: 7

                        text: "SHUTDOWN"

                        font.pixelSize: 12
                        font.weight: Font.Medium

                        color: shutdownMouse.containsMouse
                            ? Theme.Main.text
                            : Theme.Main.textSecondary
                    }


                    Text {
                        x: 13
                        y: 24

                        text: "SYSTEM POWER OFF"

                        font.pixelSize: 7
                        font.letterSpacing: 1

                        color: Theme.Main.textSecondary

                        opacity: 0.55
                    }


                    Text {
                        anchors.right: parent.right
                        anchors.rightMargin: 12

                        anchors.verticalCenter: parent.verticalCenter

                        text: "⏻"

                        font.pixelSize: 19

                        color: shutdownMouse.containsMouse
                            ? Theme.Main.border
                            : Theme.Main.textSecondary

                        Behavior on color {
                            ColorAnimation {
                                duration: 120
                            }
                        }
                    }


                    Text {
                        anchors.right: parent.right
                        anchors.rightMargin: 4

                        anchors.verticalCenter: parent.verticalCenter

                        text: "›"

                        font.pixelSize: 12

                        color: Theme.Main.border

                        opacity: shutdownMouse.containsMouse ? 0.8 : 0

                        Behavior on opacity {
                            NumberAnimation {
                                duration: 100
                            }
                        }
                    }


                    MouseArea {
                        id: shutdownMouse

                        anchors.fill: parent

                        hoverEnabled: true

                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            root.menuOpen = false

                            Quickshell.execDetached([
                                "systemctl",
                                "poweroff"
                            ])
                        }
                    }
                }


                // =================================================
                // REBOOT
                // =================================================

                Item {
                    id: rebootButton

                    x: 15
                    y: 89

                    width: parent.width - 30
                    height: 43

                    Rectangle {
                        anchors.fill: parent

                        radius: 5

                        color: rebootMouse.containsMouse
                            ? Qt.rgba(
                                Theme.Main.border.r,
                                Theme.Main.border.g,
                                Theme.Main.border.b,
                                0.09
                            )
                            : "transparent"

                        border.width: rebootMouse.containsMouse ? 1 : 0

                        border.color: Qt.rgba(
                            Theme.Main.border.r,
                            Theme.Main.border.g,
                            Theme.Main.border.b,
                            0.30
                        )

                        Behavior on color {
                            ColorAnimation {
                                duration: 120
                            }
                        }
                    }


                    Rectangle {
                        x: 3
                        y: 9

                        width: 2
                        height: 25

                        radius: 1

                        color: Theme.Main.border

                        opacity: rebootMouse.containsMouse
                            ? 1
                            : 0.25
                    }


                    Text {
                        x: 13
                        y: 7

                        text: "REBOOT"

                        font.pixelSize: 12
                        font.weight: Font.Medium

                        color: rebootMouse.containsMouse
                            ? Theme.Main.border
                            : Theme.Main.textSecondary
                    }


                    Text {
                        x: 13
                        y: 24

                        text: "SYSTEM RESTART"

                        font.pixelSize: 7
                        font.letterSpacing: 1

                        color: Theme.Main.textSecondary

                        opacity: 0.55
                    }


                    Text {
                        anchors.right: parent.right
                        anchors.rightMargin: 12

                        anchors.verticalCenter: parent.verticalCenter

                        text: "↻"

                        font.pixelSize: 20

                        color: rebootMouse.containsMouse
                            ? Theme.Main.border
                            : Theme.Main.textSecondary
                    }


                    Text {
                        anchors.right: parent.right
                        anchors.rightMargin: 4

                        anchors.verticalCenter: parent.verticalCenter

                        text: "›"

                        font.pixelSize: 12

                        color: Theme.Main.border

                        opacity: rebootMouse.containsMouse ? 0.8 : 0
                    }


                    MouseArea {
                        id: rebootMouse

                        anchors.fill: parent

                        hoverEnabled: true

                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            root.menuOpen = false

                            Quickshell.execDetached([
                                "systemctl",
                                "reboot"
                            ])
                        }
                    }
                }


                // =================================================
                // LOGOUT
                // =================================================

                Item {
                    id: logoutButton

                    x: 15
                    y: 135

                    width: parent.width - 30
                    height: 43

                    Rectangle {
                        anchors.fill: parent

                        radius: 5

                        color: logoutMouse.containsMouse
                            ? Qt.rgba(
                                Theme.Main.border.r,
                                Theme.Main.border.g,
                                Theme.Main.border.b,
                                0.09
                            )
                            : "transparent"

                        border.width: logoutMouse.containsMouse ? 1 : 0

                        border.color: Qt.rgba(
                            Theme.Main.border.r,
                            Theme.Main.border.g,
                            Theme.Main.border.b,
                            0.30
                        )
                    }


                    Rectangle {
                        x: 3
                        y: 9

                        width: 2
                        height: 25

                        radius: 1

                        color: Theme.Main.textSecondary

                        opacity: logoutMouse.containsMouse
                            ? 1
                            : 0.25
                    }


                    Text {
                        x: 13
                        y: 7

                        text: "LOGOUT"

                        font.pixelSize: 12
                        font.weight: Font.Medium

                        color: logoutMouse.containsMouse
                            ? Theme.Main.text
                            : Theme.Main.textSecondary
                    }


                    Text {
                        x: 13
                        y: 24

                        text: "END SESSION"

                        font.pixelSize: 7
                        font.letterSpacing: 1

                        color: Theme.Main.textSecondary

                        opacity: 0.55
                    }


                    Text {
                        anchors.right: parent.right
                        anchors.rightMargin: 12

                        anchors.verticalCenter: parent.verticalCenter

                        text: "⇥"

                        font.pixelSize: 19

                        color: logoutMouse.containsMouse
                            ? Theme.Main.border
                            : Theme.Main.textSecondary
                    }


                    Text {
                        anchors.right: parent.right
                        anchors.rightMargin: 4

                        anchors.verticalCenter: parent.verticalCenter

                        text: "›"

                        font.pixelSize: 12

                        color: Theme.Main.border

                        opacity: logoutMouse.containsMouse ? 0.8 : 0
                    }


                    MouseArea {
                        id: logoutMouse

                        anchors.fill: parent

                        hoverEnabled: true

                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            root.menuOpen = false

                            Quickshell.execDetached([
                                "hyprctl",
                                "dispatch",
                                "exit"
                            ])
                        }
                    }
                }

                

                // =================================================
                // BOTTOM STATUS
                // =================================================

                Row {
                    x: 16
                    y: parent.height - 19

                    spacing: 5

                    Text {
                        text: "SYS"

                        font.pixelSize: 7
                        font.weight: Font.Bold
                        font.letterSpacing: 1

                        color: Theme.Main.border
                    }

                    Text {
                        text: "ONLINE"

                        font.pixelSize: 7
                        font.letterSpacing: 1

                        color: Theme.Main.textSecondary

                        opacity: 0.65
                    }
                }


                // =================================================
                // SCANLINE
                // =================================================

                Rectangle {
                    id: scanline

                    x: 14
                    y: 40

                    width: parent.width - 28
                    height: 1

                    color: Theme.Main.border

                    opacity: 0.05

                    SequentialAnimation on y {
                        loops: Animation.Infinite

                        NumberAnimation {
                            from: 40
                            to: panel.height - 15

                            duration: 2800
                        }

                        PauseAnimation {
                            duration: 400
                        }
                    }
                }
            }
        }
    }
}