pragma Singleton

import QtQuick

QtObject {
    readonly property color bgt: Qt.rgba(0, 0, 0, .70)  // Background Transparency
    

    property int borderWidth: 1
    property int borderRadius: 1
    property color borderColor: textSecondary


    readonly property color background: "#66111111"
    readonly property color surface: '#de8817c5'
    readonly property color border: "#44FFFFFF"

    readonly property color wsActive: '#88330e93'
    readonly property color wsInactive: '#88200c62'

    readonly property color text: "#f5e2c5"
    readonly property color textSecondary: '#ff6200'
    readonly property color textAccent: '#191717'

    readonly property color accent: "#C678DD"
    readonly property color success: "#98C379"
    readonly property color warning: "#E5C07B"
    readonly property color error: "#E06C75"

    readonly property color battery1: "#ff6200"
    readonly property color battery2: '#ff0000'
    readonly property color battery3: '#ffb347'


    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 13
    property int fontWeight: Font.Normal


    property string systemName: "Sys0p"

}


