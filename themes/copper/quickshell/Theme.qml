pragma Singleton

import QtQuick

// Copper theme
QtObject {
    readonly property string fontFamily: "JetBrainsMono Nerd Font"
    readonly property string fontFamilyMono: "JetBrainsMono Nerd Font Mono"

    readonly property int fontSizeSmall:  10
    readonly property int fontSizeNormal: 14
    readonly property int fontSizeLarge:  16

    readonly property color bg: "#131722"
    readonly property color widget: "#e8e4e0"
    readonly property color border: "#3a4862"
    readonly property color textMuted: "#8a95a7"
    readonly property color text: "#f0ece8"
    readonly property color accent: "#c08850"
    readonly property color warn: "#b88a70"
    readonly property color notify: "#d45a5a"
    readonly property color positive: "#5a8a7a"

    readonly property color gradient1: "#401317"
    readonly property color gradient2: "#663837"
    readonly property color gradient3: "#8D5D57"
    readonly property color gradient4: "#B38276"
    readonly property color gradient5: "#D9A796"
}
