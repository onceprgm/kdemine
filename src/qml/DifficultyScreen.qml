import QtQuick

Column {
    spacing: 14
    anchors.centerIn: parent

    Text {
        text: (configManager.translations && configManager.translations["difficulty"]) || ""
        color: configManager.textColor
        font.pixelSize: 26
        font.bold: true
        font.family: configManager.activeTheme === "classic" ? "Courier" : "sans-serif"
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        bottomPadding: 25
    }

    MenuButton {
        text: (configManager.translations && configManager.translations["noobs"]) || ""
        enabled: false
        anchors.horizontalCenter: parent.horizontalCenter
    }

    MenuButton {
        text: (configManager.translations && configManager.translations["normal"]) || ""
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            configManager.currentScreen = "custom"
        }
    }

    MenuButton {
        text: (configManager.translations && configManager.translations["hardcore"]) || ""
        enabled: false
        anchors.horizontalCenter: parent.horizontalCenter
    }

    MenuButton {
        text: (configManager.translations && configManager.translations["back"]) || ""
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: configManager.currentScreen = "menu"
    }
}