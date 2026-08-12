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

    // Power button
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        radius: 6

        Text {
            anchors.centerIn: parent
            text: "⏻"
            font.pixelSize: 20
            color: root.menuOpen ? Theme.Main.border : Theme.Main.textSecondary

            Behavior on color { ColorAnimation { duration: 180 } }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.menuOpen = !root.menuOpen
        }
    }

    PopupWindow {
        id: popup
        visible: root.menuOpen
        width: 180
        height: 230
        color: "transparent"
        grabFocus: true

        anchor.item: root
        anchor.rect.y: root.height + 14

        Item {
            anchors.fill: parent
            focus: true
            Component.onCompleted: forceActiveFocus()
            onVisibleChanged: if (visible) forceActiveFocus()

            Keys.onPressed: (event) => {
                if (event.key === Qt.Key_Escape) {
                    root.menuOpen = false
                    event.accepted = true
                }
            }

            // Tracks the entire popup geometry (including gaps between buttons)
            HoverHandler {
                id: popupHover
                onHoveredChanged: {
                    if (!hovered)
                        closeTimer.restart()
                    else
                        closeTimer.stop()
                }
            }

            // Small delay so quick movements between buttons don't close it
            Timer {
                id: closeTimer
                interval: 80
                onTriggered: {
                    if (!popupHover.hovered)
                        root.menuOpen = false
                }
            }

            Column {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 8

                component FuturisticButton: Item {
                    id: btn

                    width: 140
                    height: 32

                    property string icon: ""
                    property string label: ""
                    property color accent: Theme.Main.textSecondary

                    signal clicked()

                    Row {
                        anchors.centerIn: parent
                        spacing: 10

                        Text {
                            text: btn.icon
                            font.pixelSize: 17
                            color: mouse.containsMouse ? btn.accent : Theme.Main.textSecondary

                            Behavior on color {
                                ColorAnimation { duration: 120 }
                            }
                        }

                        Text {
                            text: btn.label
                            font.pixelSize: 14
                            font.weight: Font.Medium
                            color: mouse.containsMouse ? btn.accent : Theme.Main.text

                            Behavior on color {
                                ColorAnimation { duration: 120 }
                            }
                        }
                    }

                    MouseArea {
                        id: mouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onClicked: btn.clicked()
                    }
                }

                FuturisticButton {
                    icon: "⏻"
                    label: "Shutdown"
                    accent: Theme.Main.textSecondary
                    onClicked: Quickshell.execDetached(["systemctl", "poweroff"])
                }

                FuturisticButton {
                    icon: "↻"
                    label: "Reboot"
                    accent: Theme.Main.textSecondary
                    onClicked: Quickshell.execDetached(["systemctl", "reboot"])
                }

                FuturisticButton {
                    icon: "⇥"
                    label: "Logout"
                    accent: Theme.Main.textSecondary
                    onClicked: Quickshell.execDetached(["hyprctl", "dispatch", "exit"])
                }

             //   FuturisticButton {
             //       icon: "✕"
             //       label: "Cancel"
             //       accent: Theme.Main.battery2
             //       onClicked: root.menuOpen = false
             //   }
            }
        }
    }
}