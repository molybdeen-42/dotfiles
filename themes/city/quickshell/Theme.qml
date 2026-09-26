pragma Singleton

import QtQuick

// City theme
QtObject {
    readonly property string fontFamily: "JetBrainsMono Nerd Font"
    readonly property string fontFamilyMono: "JetBrainsMono Nerd Font Mono"

    readonly property int fontSizeSmall:  10
    readonly property int fontSizeNormal: 14
    readonly property int fontSizeLarge:  16

    readonly property color bg: "#131415"
    readonly property color widget: "#E7E3D9"
    readonly property color border: "#38484C"
    readonly property color textMuted: "#8E8D74"
    readonly property color text: "#EBE7D7"
    readonly property color accent: "#C99F75"
    readonly property color warn: "#A39A74"
    readonly property color notify: "#9B3E4B"
    readonly property color positive: "#718856"

    readonly property color gradient1: "#8A4A6F"
    readonly property color gradient2: "#A5618B"
    readonly property color gradient3: "#C1789F"
    readonly property color gradient4: "#D494B3"
    readonly property color gradient5: "#E58FB5"
}
