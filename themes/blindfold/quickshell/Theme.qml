pragma Singleton

import QtQuick

// Blindfold theme
QtObject {
    readonly property string fontFamily: "JetBrainsMono Nerd Font"
    readonly property string fontFamilyMono: "JetBrainsMono Nerd Font Mono"

    readonly property int fontSizeSmall:  10
    readonly property int fontSizeNormal: 14
    readonly property int fontSizeLarge:  16

    readonly property color bg: "#0e1219"
    readonly property color widget: "#e8e4e0" // Fixed
    readonly property color border: "#3a4862"
    readonly property color textMuted: "#8a95a7" // Fixed
    readonly property color text: "#f0ece8" // Fixed
    readonly property color accent: "#7a9ab8"
    readonly property color warn: "#b88a70" // Fixed
    readonly property color notify: "#d45a5a" // Fixed
    readonly property color positive: "#5a8a7a" // Fixed

    readonly property color gradient1: "#7a9ab8"
    readonly property color gradient2: "#5f7890"
    readonly property color gradient3: "#445668"
    readonly property color gradient4: "#293441"
    readonly property color gradient5: "#0e1219"
}