import QtQuick
import QtQuick.Controls

Column {
    spacing: 16
    anchors.centerIn: parent

    component ThemeButton : Button {
        id: tBtn
        width: 105
        height: 38
        
        onPressed: {
            configManager.playSound("click.wav")
        }
        
        contentItem: Text {
            text: tBtn.text
            color: tBtn.enabled ? configManager.textColor : "#808080"
            font.pixelSize: 13
            font.bold: true
            font.family: configManager.activeTheme === "classic" ? "Courier" : "sans-serif"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        
        background: Rectangle {
            color: tBtn.down || tBtn.checked ? (configManager.activeTheme === "classic" ? "#b0b0b0" : "#2a2a3d") : configManager.panelColor
            radius: configManager.elementRadius
            border.width: mainWindow.activeTheme === "breeze" ? 1 : 0
            border.color: tBtn.hovered || tBtn.checked ? configManager.accentColor : "#353547"

            Rectangle {
                visible: configManager.activeTheme === "classic"
                anchors.fill: parent
                color: "transparent"

                Rectangle {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 2
                    color: tBtn.down || tBtn.checked ? "#808080" : "#ffffff"
                }
                Rectangle {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    width: 2
                    color: tBtn.down || tBtn.checked ? "#808080" : "#ffffff"
                }
                Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 2
                    color: tBtn.down || tBtn.checked ? "#ffffff" : "#808080"
                }
                Rectangle {
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: 2
                    color: tBtn.down || tBtn.checked ? "#ffffff" : "#808080"
                }
            }
        }
    }

    Text {
        text: (configManager.translations && configManager.translations["settings"]) || ""
        color: configManager.textColor
        font.pixelSize: 26
        font.bold: true
        font.family: configManager.activeTheme === "classic" ? "Courier" : "sans-serif"
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        bottomPadding: 15
    }

    Column {
        spacing: 12
        anchors.horizontalCenter: parent.horizontalCenter
        
        Text {
            text: (configManager.translations && configManager.translations["theme"]) || ""
            color: configManager.textColor
            font.bold: true
            font.pixelSize: 14
            font.family: configManager.activeTheme === "classic" ? "Courier" : "sans-serif"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Row {
            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter
            
            ThemeButton {
                text: "Breeze"
                checked: configManager.activeTheme === "breeze"
                onClicked: configManager.activeTheme = "breeze"
            }
            ThemeButton {
                text: "Classic"
                checked: configManager.activeTheme === "classic"
                onClicked: configManager.activeTheme = "classic"
            }
        }
    }

    Column {
        spacing: 12
        anchors.horizontalCenter: parent.horizontalCenter
        
        Text {
            text: (configManager.translations && configManager.translations["lang"]) || ""
            color: configManager.textColor
            font.bold: true
            font.pixelSize: 14
            font.family: configManager.activeTheme === "classic" ? "Courier" : "sans-serif"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Row {
            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter
            
            ThemeButton {
                text: "English"
                width: 80
                checked: configManager.activeLanguage === "en"
                onClicked: configManager.activeLanguage = "en"
            }
            ThemeButton {
                text: "Русский"
                width: 80
                checked: configManager.activeLanguage === "ru"
                onClicked: configManager.activeLanguage = "ru"
            }
            ThemeButton {
                text: "中文"
                width: 80
                checked: configManager.activeLanguage === "zh"
                onClicked: configManager.activeLanguage = "zh"
            }
        }
    }

    MenuButton {
        text: (configManager.translations && configManager.translations["open_config"]) || ""
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: configManager.openConfigFolder()
    }

    MenuButton {
        text: (configManager.translations && configManager.translations["back"]) || ""
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: configManager.currentScreen = "menu"
    }
}