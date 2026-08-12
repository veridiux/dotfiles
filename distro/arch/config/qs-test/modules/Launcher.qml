import Quickshell
import QtQuick
import Quickshell.Io
import QtQuick.Controls
import QtQuick.Layouts
import "../themes" as Theme

// ================================================================
// FUTURISTIC APPLICATION LAUNCHER
//
// Uses Quickshell's DesktopEntries system to find installed
// applications from the normal Linux .desktop entries.
//
// Keyboard:
//   ↑ / ↓       Move selection
//   Enter       Launch application
//   Escape      Close launcher
// ================================================================

Item {

    IpcHandler {
        target: "launcher"

        function toggle() {
            if (root.launcherOpen)
                root.closeLauncher()
            else
                root.openLauncher()
        }

        function open() {
            root.openLauncher()
        }

        function close() {
            root.closeLauncher()
        }
    }

    id: root

    // ------------------------------------------------------------
    // Launcher state
    // ------------------------------------------------------------

    property bool launcherOpen: false

    // Search text
    property string searchText: ""

    // Currently selected application
    property int selectedIndex: 0


    // ============================================================
    // FILTERED APPLICATION LIST
    // ============================================================

    // DesktopEntries.applications contains the applications that
    // should normally appear in application menus.
    //
    // We create our own filtered JavaScript array so the UI can
    // react to the search box.
    property var filteredApps: {
        var result = []

        var query = searchText.toLowerCase().trim()

        for (var i = 0;
             i < DesktopEntries.applications.values.length;
             i++) {

            var app = DesktopEntries.applications.values[i]

            // Skip anything without a usable name.
            if (!app || !app.name)
                continue

            // Don't show NoDisplay entries.
            if (app.noDisplay)
                continue

            // ----------------------------------------------------
            // No search = show everything
            // ----------------------------------------------------

            if (query === "") {
                result.push(app)
                continue
            }

            // ----------------------------------------------------
            // Search name
            // ----------------------------------------------------

            if (app.name.toLowerCase().includes(query)) {
                result.push(app)
                continue
            }

            // ----------------------------------------------------
            // Search generic name
            //
            // Example:
            // Firefox -> "Web Browser"
            // Dolphin -> "File Manager"
            // ----------------------------------------------------

            if (app.genericName &&
                app.genericName.toLowerCase().includes(query)) {

                result.push(app)
                continue
            }

            // ----------------------------------------------------
            // Search keywords
            // ----------------------------------------------------

            if (app.keywords) {

                for (var k = 0;
                     k < app.keywords.length;
                     k++) {

                    if (app.keywords[k]
                        .toLowerCase()
                        .includes(query)) {

                        result.push(app)
                        break
                    }
                }
            }
        }

        return result
    }


    // ============================================================
    // OPEN / CLOSE
    // ============================================================

    function openLauncher() {
        root.launcherOpen = true
        root.searchText = ""
        root.selectedIndex = 0

        searchField.forceActiveFocus()
    }


    function closeLauncher() {
        root.launcherOpen = false
        root.searchText = ""
        root.selectedIndex = 0
    }


    // ============================================================
    // LAUNCH SELECTED APPLICATION
    // ============================================================

    function launchSelected() {

        if (filteredApps.length === 0)
            return

        if (selectedIndex < 0)
            selectedIndex = 0

        if (selectedIndex >= filteredApps.length)
            selectedIndex = filteredApps.length - 1

        var app = filteredApps[selectedIndex]

        if (!app)
            return

        // DesktopEntry.execute() is specifically intended for
        // launching the application.
        app.execute()

        closeLauncher()
    }


    // ============================================================
    // CENTERED LAUNCHER WINDOW
    // ============================================================

    PanelWindow {
        id: launcherWindow

        visible: root.launcherOpen
        focusable: true

        implicitWidth: 600
        implicitHeight: 520

        color: Qt.rgba(0, 0, 0, .70)

        // Put the launcher on the first monitor.
        screen: Quickshell.screens[0]

        // Center the window on the monitor.
        anchors {
            top: true
            left: true
        }

        margins {
            left: (screen.width - implicitWidth) / 2
            top: (screen.height - implicitHeight) / 2
        }

        Item {
            anchors.fill: parent

            focus: true


            // ====================================================
            // ESCAPE
            // ====================================================

            Keys.onPressed: function(event) {

                if (event.key === Qt.Key_Escape) {

                    root.closeLauncher()

                    event.accepted = true
                }
            }


            // ====================================================
            // MAIN HUD
            // ====================================================

            Rectangle {
                id: panel

                anchors.fill: parent

                radius: 10

                color: Theme.Main.background

                opacity: 0.98

                border.width: 1

                border.color: Qt.rgba(
                    Theme.Main.border.r,
                    Theme.Main.border.g,
                    Theme.Main.border.b,
                    0.55
                )


                // =================================================
                // OUTER HUD GLOW
                // =================================================

                Rectangle {
                    anchors.fill: parent

                    anchors.margins: -3

                    radius: 13

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
                // TOP ACCENT
                // =================================================

                Rectangle {
                    x: 18
                    y: 0

                    width: parent.width - 36
                    height: 2

                    radius: 1

                    color: Theme.Main.border

                    opacity: 0.9
                }


                // =================================================
                // HUD CORNERS
                // =================================================

                // Top-left
                Rectangle {
                    x: 0
                    y: 12

                    width: 10
                    height: 1

                    color: Theme.Main.border
                }

                Rectangle {
                    x: 0
                    y: 12

                    width: 1
                    height: 10

                    color: Theme.Main.border
                }


                // Top-right
                Rectangle {
                    x: parent.width - 10
                    y: 12

                    width: 10
                    height: 1

                    color: Theme.Main.border
                }

                Rectangle {
                    x: parent.width - 1
                    y: 12

                    width: 1
                    height: 10

                    color: Theme.Main.border
                }


                // Bottom-left
                Rectangle {
                    x: 0
                    y: parent.height - 13

                    width: 10
                    height: 1

                    color: Theme.Main.border
                }

                Rectangle {
                    x: 0
                    y: parent.height - 23

                    width: 1
                    height: 11

                    color: Theme.Main.border
                }


                // Bottom-right
                Rectangle {
                    x: parent.width - 10
                    y: parent.height - 13

                    width: 10
                    height: 1

                    color: Theme.Main.border
                }

                Rectangle {
                    x: parent.width - 1
                    y: parent.height - 23

                    width: 1
                    height: 11

                    color: Theme.Main.border
                }


                // =================================================
                // HEADER
                // =================================================

                Row {
                    x: 20
                    y: 16

                    spacing: 8

                    Text {
                        text: "APPLICATION"

                        font.pixelSize: 11
                        font.weight: Font.Bold
                        font.letterSpacing: 2

                        color: Theme.Main.text
                    }

                    Text {
                        text: "//"

                        font.pixelSize: 10
                        font.weight: Font.Bold

                        color: Theme.Main.border
                    }

                    Text {
                        text: "LAUNCHER"

                        font.pixelSize: 9
                        font.letterSpacing: 1

                        color: Theme.Main.textSecondary
                    }
                }


                // =================================================
                // STATUS LIGHT
                // =================================================

                Rectangle {
                    x: parent.width - 27
                    y: 18

                    width: 5
                    height: 5

                    radius: 2.5

                    color: Theme.Main.border

                    opacity: 0.9
                }


                // =================================================
                // HEADER DIVIDER
                // =================================================

                Rectangle {
                    x: 18
                    y: 40

                    width: parent.width - 36
                    height: 1

                    color: Qt.rgba(
                        Theme.Main.border.r,
                        Theme.Main.border.g,
                        Theme.Main.border.b,
                        0.20
                    )
                }


                // =================================================
                // SEARCH BOX
                // =================================================

                Rectangle {
                    id: searchBox

                    x: 18
                    y: 52

                    width: parent.width - 36
                    height: 48

                    radius: 6

                    color: Qt.rgba(
                        Theme.Main.border.r,
                        Theme.Main.border.g,
                        Theme.Main.border.b,
                        0.045
                    )

                    border.width: 1

                    border.color: Qt.rgba(
                        Theme.Main.border.r,
                        Theme.Main.border.g,
                        Theme.Main.border.b,
                        0.20
                    )


                    // Search prompt
                    Text {
                        id: prompt

                        x: 15

                        anchors.verticalCenter: parent.verticalCenter

                        text: ">"

                        font {
                            family: "JetBrainsMono Nerd Font"
                            pixelSize: 17
                            weight: Font.Bold
                        }

                        color: Theme.Main.border
                    }


                    // Search input
                    TextInput {
                        id: searchField

                        x: 38
                        width: parent.width - 53

                        anchors.verticalCenter: parent.verticalCenter

                        height: 30

                        z: 2

                        text: root.searchText

                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter

                        color: Theme.Main.text

                        font {
                            family: "JetBrainsMono Nerd Font"
                            pixelSize: 13
                        }

                        selectByMouse: true
                        clip: true
                    

                        // ...
                    

                        onTextChanged: {

                            root.searchText = text

                            root.selectedIndex = 0
                        }


                        // ------------------------------------------------
                        // Keyboard navigation
                        // ------------------------------------------------

                        Keys.onPressed: function(event) {

                            // DOWN
                            if (event.key === Qt.Key_Down) {

                                if (root.filteredApps.length > 0) {

                                    root.selectedIndex =
                                        Math.min(
                                            root.selectedIndex + 1,
                                            root.filteredApps.length - 1
                                        )
                                }

                                event.accepted = true
                            }


                            // UP
                            else if (event.key === Qt.Key_Up) {

                                if (root.filteredApps.length > 0) {

                                    root.selectedIndex =
                                        Math.max(
                                            root.selectedIndex - 1,
                                            0
                                        )
                                }

                                event.accepted = true
                            }


                            // ENTER
                            else if (
                                event.key === Qt.Key_Return ||
                                event.key === Qt.Key_Enter
                            ) {

                                root.launchSelected()

                                event.accepted = true
                            }


                            // ESCAPE
                            else if (
                                event.key === Qt.Key_Escape
                            ) {

                                root.closeLauncher()

                                event.accepted = true
                            }
                        }


                        Text {
                            anchors.fill: parent

                            text: "search applications..."

                            color: Theme.Main.textSecondary

                            opacity: 0.35

                            font: searchField.font

                            verticalAlignment: Text.AlignVCenter

                            visible:
                                searchField.text.length === 0 &&
                                !searchField.activeFocus

                            z: -1
                        }
                    }


                    // Search activity indicator
                    Rectangle {
                        anchors.right: parent.right
                        anchors.rightMargin: 5

                        anchors.top: parent.top
                        anchors.topMargin: 5

                        width: 2
                        height: parent.height - 10

                        radius: 1

                        color: Theme.Main.border

                        opacity:
                            searchField.activeFocus ? 0.8 : 0.2
                    }
                }


                // =================================================
                // APPLICATION LIST
                // =================================================

                ListView {
                    id: appList

                    x: 18
                    y: 112

                    width: parent.width - 36
                    height: 330

                    clip: true

                    spacing: 4

                    model: root.filteredApps

                    currentIndex: root.selectedIndex


                    onCurrentIndexChanged: {

                        if (currentIndex !== root.selectedIndex)
                            root.selectedIndex = currentIndex
                    }


                    delegate: Item {

                        id: appDelegate

                        required property var modelData
                        required property int index

                        width: appList.width
                        height: 56


                        property bool selected:
                            index === root.selectedIndex


                        // =================================================
                        // APPLICATION BACKGROUND
                        // =================================================

                        Rectangle {
                            anchors.fill: parent

                            radius: 6

                            color: appDelegate.selected
                                ? Qt.rgba(
                                    Theme.Main.border.r,
                                    Theme.Main.border.g,
                                    Theme.Main.border.b,
                                    0.10
                                )
                                : "transparent"

                            border.width:
                                appDelegate.selected ? 1 : 0

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


                        // =================================================
                        // SELECTION BAR
                        // =================================================

                        Rectangle {
                            x: 3

                            anchors.verticalCenter: parent.verticalCenter

                            width: 2

                            height:
                                appDelegate.selected ? 32 : 0

                            radius: 1

                            color: Theme.Main.border

                            Behavior on height {
                                NumberAnimation {
                                    duration: 140
                                }
                            }
                        }


                        // =================================================
                        // APPLICATION ICON
                        // =================================================

                        Image {
                            id: appIcon

                            x: 16

                            anchors.verticalCenter: parent.verticalCenter

                            width: 34
                            height: 34

                            source:
                                modelData.icon
                                ? "image://icon/" + modelData.icon
                                : ""

                            sourceSize.width: 34
                            sourceSize.height: 34

                            fillMode: Image.PreserveAspectFit

                            smooth: true

                            opacity:
                                appDelegate.selected
                                ? 1
                                : 0.75
                        }


                        // =================================================
                        // APPLICATION NAME
                        // =================================================

                        Column {
                            x: 64

                            anchors.verticalCenter: parent.verticalCenter

                            spacing: 2

                            Text {
                                text: modelData.name

                                font {
                                    family: "JetBrainsMono Nerd Font"
                                    pixelSize: 13
                                    weight: appDelegate.selected
                                        ? Font.Bold
                                        : Font.Medium
                                }

                                color:
                                    appDelegate.selected
                                    ? Theme.Main.border
                                    : Theme.Main.text
                            }


                            Text {
                                text:
                                    modelData.genericName ||
                                    modelData.comment ||
                                    "APPLICATION"

                                font {
                                    family: "JetBrainsMono Nerd Font"
                                    pixelSize: 8
                                    letterSpacing: 0.5
                                }

                                color: Theme.Main.textSecondary

                                opacity: 0.60

                                elide: Text.ElideRight

                                width: 300
                            }
                        }


                        // =================================================
                        // CATEGORY
                        // =================================================

                        Text {
                            anchors.right: parent.right

                            anchors.rightMargin: 16

                            anchors.verticalCenter: parent.verticalCenter

                            text:
                                modelData.categories &&
                                modelData.categories.length > 0
                                ? modelData.categories[0].toUpperCase()
                                : "APP"

                            font {
                                family: "JetBrainsMono Nerd Font"
                                pixelSize: 7
                                letterSpacing: 1
                            }

                            color:
                                appDelegate.selected
                                ? Theme.Main.border
                                : Theme.Main.textSecondary

                            opacity: 0.45
                        }


                        // =================================================
                        // CLICK
                        // =================================================

                        MouseArea {
                            anchors.fill: parent

                            hoverEnabled: true
                            acceptedButtons: Qt.LeftButton

                            cursorShape: Qt.PointingHandCursor

                            onEntered: {
                                console.log("🔥 LAUNCHER ENTERED")
                                root.selectedIndex = appDelegate.index
                            }

                            onClicked: {
                                console.log("🔥 LAUNCHER CLICKED")
                                root.selectedIndex = appDelegate.index
                                root.launchSelected()
                            }
                        }
                    }


                    // =================================================
                    // NO RESULTS
                    // =================================================

                    Text {
                        anchors.centerIn: parent

                        text: "NO APPLICATIONS FOUND"

                        font {
                            family: "JetBrainsMono Nerd Font"
                            pixelSize: 10
                            weight: Font.Bold
                            letterSpacing: 2
                        }

                        color: Theme.Main.textSecondary

                        opacity: 0.45

                        visible:
                            root.filteredApps.length === 0
                    }
                }


                // =================================================
                // BOTTOM DIVIDER
                // =================================================

                Rectangle {
                    x: 18
                    y: 454

                    width: parent.width - 36
                    height: 1

                    color: Qt.rgba(
                        Theme.Main.border.r,
                        Theme.Main.border.g,
                        Theme.Main.border.b,
                        0.20
                    )
                }


                // =================================================
                // FOOTER
                // =================================================

                Row {
                    x: 20

                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 16

                    spacing: 16


                    Text {
                        text: "↑↓"

                        font {
                            family: "JetBrainsMono Nerd Font"
                            pixelSize: 8
                            weight: Font.Bold
                        }

                        color: Theme.Main.border
                    }

                    Text {
                        text: "NAVIGATE"

                        font {
                            family: "JetBrainsMono Nerd Font"
                            pixelSize: 7
                            letterSpacing: 1
                        }

                        color: Theme.Main.textSecondary

                        opacity: 0.6
                    }


                    Text {
                        text: "ENTER"

                        font {
                            family: "JetBrainsMono Nerd Font"
                            pixelSize: 8
                            weight: Font.Bold
                        }

                        color: Theme.Main.border
                    }

                    Text {
                        text: "EXECUTE"

                        font {
                            family: "JetBrainsMono Nerd Font"
                            pixelSize: 7
                            letterSpacing: 1
                        }

                        color: Theme.Main.textSecondary

                        opacity: 0.6
                    }


                    Text {
                        text: "ESC"

                        font {
                            family: "JetBrainsMono Nerd Font"
                            pixelSize: 8
                            weight: Font.Bold
                        }

                        color: Theme.Main.border
                    }

                    Text {
                        text: "CLOSE"

                        font {
                            family: "JetBrainsMono Nerd Font"
                            pixelSize: 7
                            letterSpacing: 1
                        }

                        color: Theme.Main.textSecondary

                        opacity: 0.6
                    }
                }


                // =================================================
                // APP COUNT
                // =================================================

                Text {
                    anchors.right: parent.right
                    anchors.rightMargin: 20

                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 16

                    text:
                        root.filteredApps.length +
                        " APPS"

                    font {
                        family: "JetBrainsMono Nerd Font"
                        pixelSize: 7
                        letterSpacing: 1
                    }

                    color: Theme.Main.textSecondary

                    opacity: 0.55
                }


                // =================================================
                // SCANLINE
                // =================================================

                Rectangle {
                    id: scanline

                    x: 18
                    y: 105

                    width: parent.width - 36

                    height: 1

                    color: Theme.Main.border

                    opacity: 0.045


                    SequentialAnimation on y {

                        loops: Animation.Infinite

                        NumberAnimation {
                            from: 105
                            to: 445

                            duration: 3500
                        }

                        PauseAnimation {
                            duration: 500
                        }
                    }
                }
            }


            // ====================================================
            // OPEN ANIMATION
            // ====================================================

            opacity:
                root.launcherOpen ? 1 : 0

            scale:
                root.launcherOpen ? 1 : 0.96


            Behavior on opacity {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on scale {
                NumberAnimation {
                    duration: 180
                    easing.type: Easing.OutCubic
                }
            }

            Component.onCompleted: {
                searchField.forceActiveFocus()
            }
        }
    }
}