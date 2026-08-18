import Quickshell
import QtQuick
import Quickshell.Io
import QtQuick.Controls
import QtQuick.Layouts
import "../themes" as Theme

// ================================================================
// SYS0P // APPLICATION CORE
//
// Visual redesign of the original launcher.
// The application/search/navigation logic is intentionally kept
// familiar, while the shell has been rebuilt as an asymmetric,
// cut-corner system console.
//
// Keyboard:
//   ↑ / ↓       Move selection
//   Enter       Launch application
//   Escape      Close launcher
// ================================================================

Item {
    id: root

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

    // ------------------------------------------------------------
    // Launcher state
    // ------------------------------------------------------------

    property bool launcherOpen: false
    property string searchText: ""
    property int selectedIndex: 0
    property var mouseScreen: Quickshell.screens[0]

    // ------------------------------------------------------------
    // Palette helpers
    // ------------------------------------------------------------

    property color orange: Theme.Main.border
    property color bg: Theme.Main.background
    property color text: Theme.Main.text
    property color secondary: Theme.Main.mainAccent

    function alpha(c, a) {
        return Qt.rgba(c.r, c.g, c.b, a)
    }

    // ============================================================
    // APPLICATION FILTER
    // ============================================================

    property var filteredApps: {
        var result = []
        var query = searchText.toLowerCase().trim()

        for (var i = 0;
             i < DesktopEntries.applications.values.length;
             i++) {

            var app = DesktopEntries.applications.values[i]

            if (!app || !app.name)
                continue

            if (app.noDisplay)
                continue

            if (query === "") {
                result.push(app)
                continue
            }

            if (app.name.toLowerCase().includes(query)) {
                result.push(app)
                continue
            }

            if (app.genericName &&
                app.genericName.toLowerCase().includes(query)) {
                result.push(app)
                continue
            }

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

    Process {
        id: terminalProcess
    }

    // ============================================================
    // FIND MONITOR UNDER CURSOR
    // ============================================================

    Process {
        id: cursorProcess

        command: ["hyprctl", "cursorpos"]

        stdout: SplitParser {
            onRead: data => {
                var parts = data.trim().split(",")

                if (parts.length !== 2)
                    return

                var mouseX = Number(parts[0])
                var mouseY = Number(parts[1])

                for (var i = 0; i < Quickshell.screens.length; i++) {
                    var s = Quickshell.screens[i]

                    if (mouseX >= s.x &&
                        mouseX < s.x + s.width &&
                        mouseY >= s.y &&
                        mouseY < s.y + s.height) {

                        root.mouseScreen = s
                        return
                    }
                }
            }
        }
    }

    // ============================================================
    // OPEN / CLOSE
    // ============================================================

    function openLauncher() {
        cursorProcess.running = true
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

        // ------------------------------------------------------------
        // Terminal applications
        //
        // Quickshell's DesktopEntry.execute() intentionally ignores
        // the desktop entry's runInTerminal/Terminal=true property.
        //
        // Therefore terminal applications need to be launched
        // explicitly through our terminal emulator.
        // ------------------------------------------------------------

        if (app.runInTerminal) {
            terminalProcess.command = [
                "kitty",
                "--",
                ...app.command
            ]

            terminalProcess.running = true
        }

        // ------------------------------------------------------------
        // Normal graphical applications
        // ------------------------------------------------------------

        else {
            app.execute()
        }

        closeLauncher()
    }

    // ============================================================
    // LAUNCHER WINDOW
    // ============================================================

    PanelWindow {
        id: launcherWindow

        visible: root.launcherOpen
        focusable: true

        implicitWidth: 720
        implicitHeight: 560

        color: Theme.Main.bgt

        screen: root.mouseScreen

        Rectangle {
            anchors.fill: parent

            color: Theme.Main.bgt

            border.width: Theme.Main.borderWidth
            border.color: Theme.Main.borderColor

            radius: Theme.Main.borderRadius
        }

        anchors {
            top: true
            left: true
        }

        margins {
            left: (screen.width - implicitWidth) / 2
            top: (screen.height - implicitHeight) / 2
        }

        // ========================================================
        // ROOT HUD
        // ========================================================

        Item {
            id: hud

            anchors.fill: parent
            focus: true

            opacity: root.launcherOpen ? 1 : 0
            scale: root.launcherOpen ? 1 : 0.94

            Behavior on opacity {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on scale {
                NumberAnimation {
                    duration: 190
                    easing.type: Easing.OutBack
                    easing.overshoot: 0.15
                }
            }

            Keys.onPressed: function(event) {
                if (event.key === Qt.Key_Escape) {
                    root.closeLauncher()
                    event.accepted = true
                }
            }

            // ====================================================
            // ANGULAR CHASSIS
            // ====================================================

            Canvas {
                id: chassis

                anchors.fill: parent

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.reset()

                    var w = width
                    var h = height

                    // Main silhouette.
                    // ctx.beginPath()
                    // ctx.moveTo(34, 0)
                    // ctx.lineTo(w - 34, 0)
                    // ctx.lineTo(w, 34)
                    // ctx.lineTo(w, h - 34)
                    // ctx.lineTo(w - 52, h)
                    // ctx.lineTo(92, h)
                    // ctx.lineTo(56, h - 30)
                    // ctx.lineTo(0, h - 30)
                    // ctx.lineTo(0, 34)
                    // ctx.closePath()

                    ctx.fillStyle = root.bg
                    ctx.fill()

                    // Outer orange chassis line.
                    // ctx.beginPath()
                    // ctx.moveTo(34, 1)
                    // ctx.lineTo(w - 34, 1)
                    // ctx.lineTo(w - 1, 34)
                    // ctx.lineTo(w - 1, h - 34)
                    // ctx.lineTo(w - 52, h - 1)
                    // ctx.lineTo(92, h - 1)
                    // ctx.lineTo(56, h - 31)
                    // ctx.lineTo(1, h - 31)
                    // ctx.lineTo(1, 34)
                    // ctx.closePath()

                    ctx.strokeStyle = root.alpha(root.orange, 0.72)
                    ctx.lineWidth = 1
                    ctx.stroke()

                    // Inner chassis line.
                    // ctx.beginPath()
                    // ctx.moveTo(40, 8)
                    // ctx.lineTo(w - 40, 8)
                    // ctx.lineTo(w - 8, 40)
                    // ctx.lineTo(w - 8, h - 40)
                    // ctx.lineTo(w - 57, h - 8)
                    // ctx.lineTo(96, h - 8)
                    // ctx.lineTo(63, h - 36)
                    // ctx.lineTo(8, h - 36)
                    // ctx.lineTo(8, 40)
                    // ctx.closePath()

                    ctx.strokeStyle = root.alpha(root.orange, 0.10)
                    ctx.lineWidth = 1
                    ctx.stroke()
                }

                Component.onCompleted: requestPaint()
                onWidthChanged: requestPaint()
                onHeightChanged: requestPaint()
            }

            // ====================================================
            // SIDE IDENT MARK
            // ====================================================

            Column {
                x: 10
                y: 82

                spacing: 4

                Text {
                    text: Theme.Main.systemName
                    rotation: -90

                    transformOrigin: Item.Center

                    font {
                        family: "JetBrainsMono Nerd Font"
                        pixelSize: 9
                        weight: Font.Bold
                        letterSpacing: 2
                    }

                    color: root.alpha(root.orange, 0.55)
                }

                Rectangle {
                    width: 1
                    height: 48
                    x: 4

                    color: root.alpha(root.orange, 0.30)
                }
            }

            // ====================================================
            // TOP IDENTITY STRIP
            // ====================================================

            Row {
                x: 42
                y: 22

                spacing: 9

                Text {
                    text: "Launcher"

                    font {
                        family: "JetBrainsMono Nerd Font"
                        pixelSize: 12
                        weight: Font.Bold
                        letterSpacing: 2
                    }

                    color: root.orange
                }

                Text {
                    text: "//"

                    font {
                        family: "JetBrainsMono Nerd Font"
                        pixelSize: 10
                        weight: Font.Bold
                    }

                    color: root.alpha(root.secondary, 0.65)
                }

                Text {
                    text: "APPLICATION CORE"

                    font {
                        family: "JetBrainsMono Nerd Font"
                        pixelSize: 9
                        letterSpacing: 1.5
                    }

                    color: root.text
                }
            }

            // Small status readout.
            Row {
                anchors.right: parent.right
                anchors.rightMargin: 46
                y: 23

                spacing: 7

                Rectangle {
                    width: 5
                    height: 5
                    radius: 2.5

                    anchors.verticalCenter: parent.verticalCenter

                    color: root.orange

                    SequentialAnimation on opacity {
                        loops: Animation.Infinite

                        NumberAnimation {
                            from: 1
                            to: 0.25
                            duration: 800
                        }

                        NumberAnimation {
                            from: 0.25
                            to: 1
                            duration: 800
                        }
                    }
                }

                Text {
                    text: "LOCAL // READY"

                    font {
                        family: "JetBrainsMono Nerd Font"
                        pixelSize: 7
                        letterSpacing: 1
                    }

                    color: root.alpha(root.secondary, 0.65)
                }
            }

            // ====================================================
            // TOP TECHNICAL DIVIDER
            // ====================================================

            Rectangle {
                x: 42
                y: 48
                width: parent.width - 84
                height: 1

                color: root.alpha(root.orange, 0.20)
            }

            // ====================================================
            // SEARCH MODULE
            // ====================================================

            Rectangle {
                id: searchModule

                x: 42
                y: 66

                width: parent.width - 84
                height: 58

                color: root.alpha(root.orange, 0.035)

                border.width: 1
                border.color: root.alpha(root.orange, 0.24)

                // Angular top-right marker.
                Rectangle {
                    anchors.right: parent.right
                    anchors.top: parent.top

                    width: 42
                    height: 1

                    color: root.orange
                    opacity: 0.65
                }

                Rectangle {
                    anchors.right: parent.right
                    anchors.top: parent.top

                    width: 1
                    height: 17

                    color: root.orange
                    opacity: 0.65
                }

                // Search prompt.
                Text {
                    x: 15
                    anchors.verticalCenter: parent.verticalCenter

                    text: ">"
                    font {
                        family: "JetBrainsMono Nerd Font"
                        pixelSize: 20
                        weight: Font.Bold
                    }

                    color: root.orange
                }

                Text {
                    x: 35
                    y: 8

                    text: "COMMAND"
                    font {
                        family: "JetBrainsMono Nerd Font"
                        pixelSize: 6
                        weight: Font.Bold
                        letterSpacing: 1.5
                    }

                    color: root.alpha(root.secondary, 0.45)
                }

                TextInput {
                    id: searchField

                    x: 35
                    y: 22

                    width: parent.width - 52
                    height: 27

                    text: root.searchText

                    color: root.text

                    font {
                        family: "JetBrainsMono Nerd Font"
                        pixelSize: 13
                    }

                    selectByMouse: true
                    clip: true

                    onTextChanged: {
                        root.searchText = text
                        root.selectedIndex = 0
                    }

                    Keys.onPressed: function(event) {
                        if (event.key === Qt.Key_Down) {
                            if (root.filteredApps.length > 0)
                                root.selectedIndex =
                                    Math.min(
                                        root.selectedIndex + 1,
                                        root.filteredApps.length - 1
                                    )

                            event.accepted = true
                        }
                        else if (event.key === Qt.Key_Up) {
                            if (root.filteredApps.length > 0)
                                root.selectedIndex =
                                    Math.max(
                                        root.selectedIndex - 1,
                                        0
                                    )

                            event.accepted = true
                        }
                        else if (
                            event.key === Qt.Key_Return ||
                            event.key === Qt.Key_Enter
                        ) {
                            root.launchSelected()
                            event.accepted = true
                        }
                        else if (event.key === Qt.Key_Escape) {
                            root.closeLauncher()
                            event.accepted = true
                        }
                    }

                    Text {
                        anchors.fill: parent

                        text: "search applications..."

                        color: root.secondary
                        opacity: 0.35

                        font: searchField.font
                        verticalAlignment: Text.AlignVCenter

                        visible:
                            searchField.text.length === 0 &&
                            !searchField.activeFocus

                        z: -1
                    }
                }

                // Focus rail.
                Rectangle {
                    anchors.right: parent.right
                    anchors.rightMargin: 7
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom

                    width: 2

                    color: root.orange

                    opacity:
                        searchField.activeFocus ? 0.85 : 0.16

                    Behavior on opacity {
                        NumberAnimation { duration: 150 }
                    }
                }
            }

            // ====================================================
            // LIST HEADER
            // ====================================================

            Row {
                x: 44
                y: 140

                spacing: 10

                Text {
                    text: "01"

                    font {
                        family: "JetBrainsMono Nerd Font"
                        pixelSize: 8
                        weight: Font.Bold
                    }

                    color: root.orange
                }

                Text {
                    text: "AVAILABLE APPLICATIONS"

                    font {
                        family: "JetBrainsMono Nerd Font"
                        pixelSize: 8
                        letterSpacing: 1.2
                    }

                    color: root.alpha(root.secondary, 0.65)
                }

                Rectangle {
                    width: 250
                    height: 1

                    anchors.verticalCenter: parent.verticalCenter

                    color: root.alpha(root.orange, 0.15)
                }
            }

            // ====================================================
            // APPLICATION LIST
            // ====================================================

            ListView {
                id: appList

                x: 42
                y: 163

                width: parent.width - 84
                height: 300

                clip: true
                spacing: 5

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
                    height: 55

                    property bool selected:
                        index === root.selectedIndex

                    // ------------------------------------------------
                    // Recessed application slot.
                    // ------------------------------------------------

                    Rectangle {
                        anchors.fill: parent

                        color: appDelegate.selected
                            ? root.alpha(root.orange, 0.065)
                            : root.alpha(root.text, 0.018)

                        border.width: 1

                        border.color:
                            appDelegate.selected
                                ? root.alpha(root.orange, 0.48)
                                : root.alpha(root.secondary, 0.07)

                        Behavior on color {
                            ColorAnimation { duration: 100 }
                        }

                        Behavior on border.color {
                            ColorAnimation { duration: 100 }
                        }
                    }

                    // ------------------------------------------------
                    // Orange selection circuit.
                    // ------------------------------------------------

                    Rectangle {
                        x: 0
                        y: 8

                        width: appDelegate.selected ? 3 : 0
                        height: 39

                        color: root.orange

                        Behavior on width {
                            NumberAnimation {
                                duration: 120
                                easing.type: Easing.OutCubic
                            }
                        }
                    }

                    Rectangle {
                        visible: appDelegate.selected

                        x: 3
                        y: 8

                        width: 13
                        height: 1

                        color: root.orange
                    }

                    Rectangle {
                        visible: appDelegate.selected

                        x: 3
                        y: 46

                        width: 13
                        height: 1

                        color: root.orange
                    }

                    // ------------------------------------------------
                    // Application icon.
                    // ------------------------------------------------

                    Image {
                        id: appIcon

                        x: 22
                        anchors.verticalCenter: parent.verticalCenter

                        width: 31
                        height: 31

                        source:
                            modelData.icon
                                ? "image://icon/" + modelData.icon
                                : ""

                        sourceSize.width: 31
                        sourceSize.height: 31

                        fillMode: Image.PreserveAspectFit
                        smooth: true

                        opacity:
                            appDelegate.selected ? 1 : 0.62

                        Behavior on opacity {
                            NumberAnimation { duration: 100 }
                        }
                    }

                    // ------------------------------------------------
                    // Application identity.
                    // ------------------------------------------------

                    Column {
                        x: 70

                        anchors.verticalCenter: parent.verticalCenter

                        spacing: 2

                        Text {
                            text: modelData.name

                            font {
                                family: "JetBrainsMono Nerd Font"
                                pixelSize: 12
                                weight:
                                    appDelegate.selected
                                        ? Font.Bold
                                        : Font.Medium
                            }

                            color:
                                appDelegate.selected
                                    ? root.orange
                                    : root.text
                        }

                        Text {
                            text:
                                modelData.genericName ||
                                modelData.comment ||
                                "APPLICATION"

                            font {
                                family: "JetBrainsMono Nerd Font"
                                pixelSize: 8
                                letterSpacing: 0.4
                            }

                            color: root.secondary
                            opacity: 0.58

                            elide: Text.ElideRight
                            width: 330
                        }
                    }

                    // ------------------------------------------------
                    // Category / index.
                    // ------------------------------------------------

                    Text {
                        anchors.right: parent.right
                        anchors.rightMargin: 21

                        anchors.verticalCenter: parent.verticalCenter

                        text:
                            (index + 1).toString().padStart(2, "0") +
                            "  " +
                            (
                                modelData.categories &&
                                modelData.categories.length > 0
                                    ? modelData.categories[0].toUpperCase()
                                    : "APP"
                            )

                        font {
                            family: "JetBrainsMono Nerd Font"
                            pixelSize: 7
                            letterSpacing: 0.8
                        }

                        color:
                            appDelegate.selected
                                ? root.orange
                                : root.secondary

                        opacity: appDelegate.selected ? 0.8 : 0.35
                    }

                    // ------------------------------------------------
                    // Mouse interaction.
                    // ------------------------------------------------

                    MouseArea {
                        anchors.fill: parent

                        hoverEnabled: true
                        acceptedButtons: Qt.LeftButton

                        cursorShape: Qt.PointingHandCursor

                        onEntered: {
                            root.selectedIndex = appDelegate.index
                        }

                        onClicked: {
                            root.selectedIndex = appDelegate.index
                            root.launchSelected()
                        }
                    }
                }

                // ----------------------------------------------------
                // No results.
                // ----------------------------------------------------

                Text {
                    anchors.centerIn: parent

                    text: "NO APPLICATIONS // NULL RESULT"

                    font {
                        family: "JetBrainsMono Nerd Font"
                        pixelSize: 9
                        weight: Font.Bold
                        letterSpacing: 1.5
                    }

                    color: root.secondary
                    opacity: 0.40

                    visible: root.filteredApps.length === 0
                }
            }

            // ====================================================
            // LOWER TECHNICAL PANEL
            // ====================================================

            Rectangle {
                x: 42
                y: 478

                width: parent.width - 84
                height: 1

                color: root.alpha(root.orange, 0.18)
            }

            Row {
                x: 44
                y: 495

                spacing: 8

                Text {
                    text: "↑↓"

                    font {
                        family: "JetBrainsMono Nerd Font"
                        pixelSize: 8
                        weight: Font.Bold
                    }

                    color: root.orange
                }

                Text {
                    text: "SELECT"

                    font {
                        family: "JetBrainsMono Nerd Font"
                        pixelSize: 7
                        letterSpacing: 1
                    }

                    color: root.secondary
                    opacity: 0.55
                }

                Text {
                    text: "↵"

                    font {
                        family: "JetBrainsMono Nerd Font"
                        pixelSize: 8
                        weight: Font.Bold
                    }

                    color: root.orange
                }

                Text {
                    text: "RUN"

                    font {
                        family: "JetBrainsMono Nerd Font"
                        pixelSize: 7
                        letterSpacing: 1
                    }

                    color: root.secondary
                    opacity: 0.55
                }

                Text {
                    text: "ESC"

                    font {
                        family: "JetBrainsMono Nerd Font"
                        pixelSize: 8
                        weight: Font.Bold
                    }

                    color: root.orange
                }

                Text {
                    text: "EXIT"

                    font {
                        family: "JetBrainsMono Nerd Font"
                        pixelSize: 7
                        letterSpacing: 1
                    }

                    color: root.secondary
                    opacity: 0.55
                }
            }

            // Right-side system telemetry.
            Column {
                anchors.right: parent.right
                anchors.rightMargin: 47
                y: 493

                spacing: 2

                Text {
                    anchors.right: parent.right

                    text:
                        root.filteredApps.length +
                        " APPLICATIONS"

                    font {
                        family: "JetBrainsMono Nerd Font"
                        pixelSize: 7
                        letterSpacing: 1
                    }

                    color: root.secondary
                    opacity: 0.55
                }

                Text {
                    anchors.right: parent.right

                    text: "SESSION // LOCAL"

                    font {
                        family: "JetBrainsMono Nerd Font"
                        pixelSize: 6
                        letterSpacing: 1
                    }

                    color: root.orange
                    opacity: 0.50
                }
            }

            // ====================================================
            // CORNER HARDWARE MARKERS
            // ====================================================

            // Upper-left.
            Rectangle {
                x: 17
                y: 37
                width: 17
                height: 1
                color: root.orange
                opacity: 0.35
            }

            Rectangle {
                x: 17
                y: 37
                width: 1
                height: 17
                color: root.orange
                opacity: 0.35
            }

            // Lower-left.
            Rectangle {
                x: 17
                y: parent.height - 54
                width: 17
                height: 1
                color: root.orange
                opacity: 0.35
            }

            Rectangle {
                x: 17
                y: parent.height - 70
                width: 1
                height: 17
                color: root.orange
                opacity: 0.35
            }

            // ====================================================
            // SCANLINE
            // ====================================================

            Rectangle {
                id: scanline

                x: 42
                y: 160

                width: parent.width - 84
                height: 1

                color: root.orange
                opacity: 0.035

                SequentialAnimation on y {
                    loops: Animation.Infinite

                    NumberAnimation {
                        from: 160
                        to: 463
                        duration: 3800
                    }

                    PauseAnimation {
                        duration: 450
                    }
                }
            }
        }

        Component.onCompleted: {
            searchField.forceActiveFocus()
        }
    }
}
