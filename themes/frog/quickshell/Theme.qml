pragma Singleton

import QtQuick

// Frog theme
QtObject {
    readonly property string fontFamily: "JetBrainsMono Nerd Font"
    readonly property string fontFamilyMono: "JetBrainsMono Nerd Font Mono"

    readonly property int fontSizeSmall:  10
    readonly property int fontSizeNormal: 14
    readonly property int fontSizeLarge:  16

    readonly property color bg: "#0d130e"
    readonly property color widget: "#e4e6da"
    readonly property color border: "#3a5a48"
    readonly property color textMuted: "#8fa192"
    readonly property color text: "#ecf0e6"
    readonly property color accent: "#7aa050"
    readonly property color warn: "#ce9c1b"
    readonly property color notify: "#c95a4a"
    readonly property color positive: "#5a7a94"

    readonly property color gradient1: "#7aa050"
    readonly property color gradient2: "#5f7a3a"
    readonly property color gradient3: "#44563e"
    readonly property color gradient4: "#293428"
    readonly property color gradient5: "#0d130e"
}
