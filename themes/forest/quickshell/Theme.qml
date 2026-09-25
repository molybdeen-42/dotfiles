pragma Singleton

import QtQuick

// Forest theme
QtObject {
    readonly property string fontFamily: "JetBrainsMono Nerd Font"
    readonly property string fontFamilyMono: "JetBrainsMono Nerd Font Mono"

    readonly property int fontSizeSmall:  10
    readonly property int fontSizeNormal: 14
    readonly property int fontSizeLarge:  16

    readonly property color bg: "#1c1610"
    readonly property color widget: "#f2f5ef"
    readonly property color border: "#6e664e"
    readonly property color textMuted: "#8ba98c"
    readonly property color text: "#e8f0e4"
    readonly property color accent: "#4a7c59"
    readonly property color warn: "#d4a373"
    readonly property color notify: "#ff6b35"
    readonly property color positive: "#06d6a0"

    readonly property color gradient1: "#8bac8c"
    readonly property color gradient2: "#6d9a7b"
    readonly property color gradient3: "#4a7c59"
    readonly property color gradient4: "#33543f"
    readonly property color gradient5: "#1c1610"
}
