pragma Singleton

import QtQuick

// Thread theme
QtObject {
    readonly property string fontFamily: "JetBrainsMono Nerd Font"
    readonly property string fontFamilyMono: "JetBrainsMono Nerd Font Mono"

    readonly property int fontSizeSmall:  10
    readonly property int fontSizeNormal: 14
    readonly property int fontSizeLarge:  16

    readonly property color bg: "#0b1224"
    readonly property color widget: "#d5e8fa"
    readonly property color border: "#293c5b"
    readonly property color textMuted: "#8ca3c2"
    readonly property color text: "#eaf5ff"
    readonly property color accent: "#48b5f5"
    readonly property color warn: "#cd6676"
    readonly property color notify: "#f05c70"
    readonly property color positive: "#7bd4c2"

    readonly property color gradient1: "#48b5f5"
    readonly property color gradient2: "#9cdcff"
    readonly property color gradient3: "#628dcc"
    readonly property color gradient4: "#233a66"
    readonly property color gradient5: "#0b1224"
}
