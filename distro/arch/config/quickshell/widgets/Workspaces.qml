import QtQuick
import "../theme/"

Row {
    spacing: 6

    property int activeWorkspace: 1
    property var workspaces: []

   Component.onCompleted: {
    console.log("workspace rows:", workspaces.rowCount())

    for (let i = 0; i < workspaces.rowCount(); i++) {
        let index = workspaces.index(i, 0)
        console.log("workspace", i, workspaces.data(index))
    }
}

    Repeater {
        model: workspaces

        Text {
            text: modelData.id

            color: modelData.id === activeWorkspace
                ? Colors.accent
                : Colors.text

            font.bold: modelData.id === activeWorkspace
        }
    }
}