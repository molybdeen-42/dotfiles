pragma Singleton

import QtQuick

// Graffiti theme
QtObject {
    readonly property string fontFamily: "JetBrainsMono Nerd Font"
    readonly property string fontFamilyMono: "JetBrainsMono Nerd Font Mono"

    readonly property int fontSizeSmall:  10
    readonly property int fontSizeNormal: 14
    readonly property int fontSizeLarge:  16

    readonly property color bg: "#141a1b"
    readonly property color widget: "#d1d9d4"
    readonly property color border: "#2c3a3b"
    readonly property color textMuted: "#8aa39b"
    readonly property color text: "#e3ebe6"
    readonly property color accent: "#cb58be"
    readonly property color warn: "#c6c354"
    readonly property color notify: "#b85a66"
    readonly property color positive: "#4ca658"

    readonly property color gradient1: "#cb58be"
    readonly property color gradient2: "#59c2a5"
    readonly property color gradient3: "#5f6498"
    readonly property color gradient4: "#315d56"
    readonly property color gradient5: "#141a1b"
}
