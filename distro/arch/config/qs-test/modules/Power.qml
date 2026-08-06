import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

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
            color: root.menuOpen ? '#18e201' : "#e0e0e0"

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

        anchor.item: root
        anchor.rect.y: root.height + 14

        // Transparent container – no box
        Item {
            anchors.fill: parent

            Column {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 8

                // Futuristic pill button
                component FuturisticButton: Item {
                    id: btn

                    width: 140
                    height: 32

                    property string icon: ""
                    property string label: ""
                    property color accent: "#18e201"

                    signal clicked()

                    Row {
                        anchors.centerIn: parent
                        spacing: 10

                        Text {
                            text: btn.icon
                            font.pixelSize: 17
                            color: mouse.containsMouse ? btn.accent : "#cfcfcf"

                            Behavior on color {
                                ColorAnimation { duration: 120 }
                            }
                        }

                        Text {
                            text: btn.label
                            font.pixelSize: 14
                            font.weight: Font.Medium
                            color: mouse.containsMouse ? btn.accent : "#f0f0f0"

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
                    accent: "#18e201"
                    onClicked: Quickshell.execDetached(["systemctl", "poweroff"])
                }

                FuturisticButton {
                    icon: "↻"
                    label: "Reboot"
                    accent: "#18e201"
                    onClicked: Quickshell.execDetached(["systemctl", "reboot"])
                }

                FuturisticButton {
                    icon: "⇥"
                    label: "Logout"
                    accent: "#18e201"
                    onClicked: Quickshell.execDetached(["hyprctl", "dispatch", "exit"])
                }

                FuturisticButton {
                    icon: "✕"
                    label: "Cancel"
                    accent: '#e20101'
                    onClicked: root.menuOpen = false
                }
            }
        }
    }
}