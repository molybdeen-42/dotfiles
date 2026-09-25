pragma Singleton

import QtQuick

// Spooky theme
QtObject {
    readonly property string fontFamily: "JetBrainsMono Nerd Font"
    readonly property string fontFamilyMono: "JetBrainsMono Nerd Font Mono"

    readonly property int fontSizeSmall:  10
    readonly property int fontSizeNormal: 14
    readonly property int fontSizeLarge:  16

    readonly property color bg: "#0a0e17"
    readonly property color widget: "#e8e8e8"
    readonly property color border: "#4a4e69"
    readonly property color textMuted: "#8a8fa8"
    readonly property color text: "#e9eef5"
    readonly property color accent: "#d16b4f"
    readonly property color warn: "#e8a87c"
    readonly property color notify: "#b83a3a"
    readonly property color positive: "#5f8a80"

    readonly property color gradient1: "#d16b4f"
    readonly property color gradient2: "#a85546"
    readonly property color gradient3: "#533483"
    readonly property color gradient4: "#16213e"
    readonly property color gradient5: "#0a0e17"
}
