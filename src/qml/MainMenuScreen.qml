import QtQuick

Column {
    spacing: 14
    anchors.centerIn: parent

    MineLogo {
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Text {
        text: (configManager.translations && configManager.translations["title"]) || ""
        color: configManager.textColor
        font.pixelSize: 38
        font.bold: true
        font.family: configManager.activeTheme === "classic" ? "Courier" : "sans-serif"
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Text {
        text: (configManager.translations && configManager.translations["subtitle"]) || ""
        color: configManager.activeTheme === "classic" ? "#000000" : "#5c5c70"
        font.pixelSize: 13
        font.bold: true
        font.family: configManager.activeTheme === "classic" ? "Courier" : "sans-serif"
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        bottomPadding: 25
    }

    MenuButton {
        text: (configManager.translations && configManager.translations["new_game"]) || ""
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: configManager.currentScreen = "difficulty"
    }

    MenuButton {
        text: (configManager.translations && configManager.translations["settings"]) || ""
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: configManager.currentScreen = "settings"
    }

    MenuButton {
        text: (configManager.translations && configManager.translations["exit"]) || ""
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: Qt.quit()
    }
}