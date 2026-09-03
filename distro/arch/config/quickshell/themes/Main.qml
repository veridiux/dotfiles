pragma Singleton

import QtQuick

QtObject {

    //SET COLORS
    readonly property color c1: '#ff6200'
    readonly property color c2: '#ff0000'
    readonly property color c3: '#129ada'
    readonly property color c4: '#12da12'
    readonly property color c5: '#5812da'

    property string systemName: "Sys0p"


    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 13
    property int fontWeight: Font.Normal


    
    

    property int borderWidth: 1
    property int borderRadius: 1
    property color borderColor: mainAccent

    readonly property color bgt: Qt.rgba(0, 0, 0, .70)  // Background Transparency

    readonly property color mainAccent: c1
    readonly property color border: "#44FFFFFF"
    readonly property color background: "#66111111"
    readonly property color text: "#f5e2c5"

    readonly property color battery1: "#ff6200"
    readonly property color battery2: '#ff0000'
    readonly property color battery3: '#ffb347'
}


