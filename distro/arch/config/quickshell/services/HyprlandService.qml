import QtQuick
import Quickshell.Hyprland

QtObject {
    property var focusedWorkspace: Hyprland.focusedWorkspace
    property var workspaces: Hyprland.workspaces

    Component.onCompleted: {
        console.log("SERVICE CREATED")
        console.log("Focused:", focusedWorkspace)
        console.log("Workspaces:", workspaces)
    }

    onFocusedWorkspaceChanged: {
        console.log("FOCUSED CHANGED:", focusedWorkspace)
    }

    onWorkspacesChanged: {
        console.log("WORKSPACES CHANGED:", workspaces)
    }
}