pragma Singleton

import QtQuick

// Ronin theme
QtObject {
    readonly property string fontFamily: "JetBrainsMono Nerd Font"
    readonly property string fontFamilyMono: "JetBrainsMono Nerd Font Mono"

    readonly property int fontSizeSmall:  10
    readonly property int fontSizeNormal: 14
    readonly property int fontSizeLarge:  16

    readonly property color bg: "#13171a"
    readonly property color widget: "#d2cfd1"
    readonly property color border: "#2e3539"
    readonly property color textMuted: "#8f8a90"
    readonly property color text: "#e3e0e0"
    readonly property color accent: "#af5951"
    readonly property color warn: "#ca8e71"
    readonly property color notify: "#c06058"
    readonly property color positive: "#7a817d"

    readonly property color gradient1: "#af5951"
    readonly property color gradient2: "#ca8e71"
    readonly property color gradient3: "#9d7887"
    readonly property color gradient4: "#51363e"
    readonly property color gradient5: "#13171a"
}
