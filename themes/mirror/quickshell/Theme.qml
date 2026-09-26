pragma Singleton

import QtQuick

// Mirror theme
QtObject {
    readonly property string fontFamily: "JetBrainsMono Nerd Font"
    readonly property string fontFamilyMono: "JetBrainsMono Nerd Font Mono"

    readonly property int fontSizeSmall:  10
    readonly property int fontSizeNormal: 14
    readonly property int fontSizeLarge:  16

    readonly property color bg: "#12100d"
    readonly property color widget: "#d6d0c6"
    readonly property color border: "#3a3226"
    readonly property color textMuted: "#92896e"
    readonly property color text: "#e6e0d4"
    readonly property color accent: "#b39a5f"
    readonly property color warn: "#b08560"
    readonly property color notify: "#b85a4a"
    readonly property color positive: "#7e8164"

    readonly property color gradient1: "#b39a5f"
    readonly property color gradient2: "#8f7a4a"
    readonly property color gradient3: "#6b5c38"
    readonly property color gradient4: "#3e3626"
    readonly property color gradient5: "#12100d"
}
