pragma Singleton

import QtQuick

// Copper theme
QtObject {
    readonly property string fontFamily: "JetBrainsMono Nerd Font"
    readonly property string fontFamilyMono: "JetBrainsMono Nerd Font Mono"

    readonly property int fontSizeSmall:  10
    readonly property int fontSizeNormal: 14
    readonly property int fontSizeLarge:  16

    readonly property color bg: "#111626"
    readonly property color widget: "#e8e4e0" // Fixed
    readonly property color border: "#D9A796"
    readonly property color textMuted: "#8a95a7" // Fixed
    readonly property color text: "#f0ece8" // Fixed
    readonly property color accent: "#467362"
    readonly property color warn: "#b88a70" // Fixed
    readonly property color notify: "#d45a5a" // Fixed
    readonly property color positive: "#5a8a7a" // Fixed

    readonly property color gradient1: "#401317"
    readonly property color gradient2: "#663837"
    readonly property color gradient3: "#8D5D57"
    readonly property color gradient4: "#B38276"
    readonly property color gradient5: "#D9A796"
}