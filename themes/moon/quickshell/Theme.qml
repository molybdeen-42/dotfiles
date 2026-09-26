pragma Singleton

import QtQuick

// Moon theme
QtObject {
    readonly property string fontFamily: "JetBrainsMono Nerd Font"
    readonly property string fontFamilyMono: "JetBrainsMono Nerd Font Mono"

    readonly property int fontSizeSmall:  10
    readonly property int fontSizeNormal: 14
    readonly property int fontSizeLarge:  16

    readonly property color bg: "#141726"
    readonly property color widget: "#dce2ee"
    readonly property color border: "#3a4266"
    readonly property color textMuted: "#8a94b8"
    readonly property color text: "#e2e8f4"
    readonly property color accent: "#7095cc"
    readonly property color warn: "#b8a45f"
    readonly property color notify: "#c95f5f"
    readonly property color positive: "#6c64a8"

    readonly property color gradient1: "#7095cc"
    readonly property color gradient2: "#536498"
    readonly property color gradient3: "#374767"
    readonly property color gradient4: "#232b45"
    readonly property color gradient5: "#141726"
}
