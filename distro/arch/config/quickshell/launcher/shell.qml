import Quickshell
import Quickshell.Wayland
import QtQuick

ShellRoot {
    id: root

    // Shared state
    property bool launcherOpen: false
    property bool settingsOpen: false

    // Theme (keep it simple at first)
    readonly property color bg: "#1e1e2e"
    readonly property color surface: "#313244"
    readonly property color text: "#cdd6f4"
    readonly property color accent: "#89b4fa"
    readonly property color muted: "#6c7086"

    // Launcher
    Launcher {
        id: launcher
        visible: root.launcherOpen
        onClosed: root.launcherOpen = false
        onOpenSettings: {
            root.launcherOpen = false
            root.settingsOpen = true
        }
    }

    // Settings Panel
    SettingsPanel {
        id: settings
        visible: root.settingsOpen
        onClosed: root.settingsOpen = false
    }

    // IPC so Hyprland can toggle them
    IpcHandler {
        target: "launcher"
        function toggle() { root.launcherOpen = !root.launcherOpen }
        function show()   { root.launcherOpen = true }
        function hide()   { root.launcherOpen = false }
    }

    IpcHandler {
        target: "settings"
        function toggle() { root.settingsOpen = !root.settingsOpen }
        function show()   { root.settingsOpen = true }
        function hide()   { root.settingsOpen = false }
    }

    // Optional: GlobalShortcuts (no qs client fork on hot path)
    GlobalShortcut {
        name: "launcher-toggle"
        description: "Toggle app launcher"
        onPressed: root.launcherOpen = !root.launcherOpen
    }

    GlobalShortcut {
        name: "settings-toggle"
        description: "Toggle settings panel"
        onPressed: root.settingsOpen = !root.settingsOpen
    }
}
