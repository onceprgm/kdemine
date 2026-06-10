import "."
import QtQuick
import QtQuick.Controls

Window {
    id: mainWindow
    width: 640
    height: 680
    minimumWidth: 450
    minimumHeight: 550
    visible: true
    title: "KDE Mine"

    Rectangle {
        anchors.fill: parent
        color: configManager.backgroundColor
        z: -1
    }

    Rectangle {
        id: flashOverlay
        anchors.fill: parent
        color: "#ff0000"
        opacity: 0.0
        z: 100
        visible: opacity > 0
    }

    Connections {
        target: gameEngine
        function onGameStateChanged() {
            if (gameEngine.gameState === "lost") {
                flashOverlay.color = "#ff0000"
                lostAnimation.start()
            } else if (gameEngine.gameState === "won") {
                flashOverlay.color = "#00ff66"
                wonAnimation.start()
            }
        }
    }

    SequentialAnimation {
        id: lostAnimation
        PropertyAnimation { target: flashOverlay; property: "opacity"; from: 0.8; to: 0.0; duration: 400; easing.type: Easing.OutQuad }
    }

    SequentialAnimation {
        id: wonAnimation
        PropertyAnimation { target: flashOverlay; property: "opacity"; from: 0.4; to: 0.0; duration: 400; easing.type: Easing.OutQuad }
    }

    // TODO: Connect C++ signal handlers for game loop actions

    TapHandler {
        acceptedButtons: Qt.RightButton
        onTapped: (eventPoint) => contextMenu.popup()
    }

    component RadioMenuItem : MenuItem {
        id: menuItem
        checkable: true
        
        indicator: Rectangle {
            implicitWidth: Style.contextMenuIndicatorSize
            implicitHeight: Style.contextMenuIndicatorSize
            x: menuItem.mirrored ? menuItem.width - width - menuItem.rightPadding : menuItem.leftPadding
            y: menuItem.topPadding + (menuItem.availableHeight - height) / 2
            radius: Style.contextMenuIndicatorSize / 2
            color: "transparent"
            border.color: configManager.textColor
            border.width: 1

            Rectangle {
                width: Style.contextMenuIndicatorDotSize
                height: Style.contextMenuIndicatorDotSize
                anchors.centerIn: parent
                radius: Style.contextMenuIndicatorDotSize / 2
                color: configManager.accentColor
                visible: menuItem.checked
            }
        }
    }

    Menu {
        id: contextMenu
        
        MenuItem {
            text: (configManager.translations && configManager.translations["abandon"]) || ""
            enabled: configManager.currentScreen === "game"
            onTriggered: configManager.currentScreen = "menu"
        }
        
        Menu {
            title: (configManager.translations && configManager.translations["theme"]) || ""
            RadioMenuItem {
                text: "Breeze Dark"
                checked: configManager.activeTheme === "breeze"
                onTriggered: configManager.activeTheme = "breeze"
            }
            RadioMenuItem {
                text: "Classic Retro"
                checked: configManager.activeTheme === "classic"
                onTriggered: configManager.activeTheme = "classic"
            }
        }

        Menu {
            title: (configManager.translations && configManager.translations["lang"]) || ""
            RadioMenuItem {
                text: "English"
                checked: configManager.activeLanguage === "en"
                onTriggered: configManager.activeLanguage = "en"
            }
            RadioMenuItem {
                text: "Русский"
                checked: configManager.activeLanguage === "ru"
                onTriggered: configManager.activeLanguage = "ru"
            }
            RadioMenuItem {
                text: "中文"
                checked: configManager.activeLanguage === "zh"
                onTriggered: configManager.activeLanguage = "zh"
            }
        }
        
        MenuSeparator {}
        
        MenuItem {
            text: ((configManager.translations && configManager.translations["settings"]) || "") + "..."
            onTriggered: configManager.currentScreen = "settings"
        }
        
        MenuSeparator {}
        
        MenuItem {
            text: (configManager.translations && configManager.translations["exit"]) || ""
            onTriggered: Qt.quit()
        }
    }

    Item {
        id: container
        anchors.fill: parent

        MainMenuScreen {
            anchors.centerIn: parent
            visible: configManager.currentScreen === "menu"
        }

        DifficultyScreen {
            anchors.centerIn: parent
            visible: configManager.currentScreen === "difficulty"
        }

        CustomScreen {
            anchors.centerIn: parent
            visible: configManager.currentScreen === "custom"
        }

        SettingsScreen {
            anchors.centerIn: parent
            visible: configManager.currentScreen === "settings"
        }

        GameScreen {
            anchors.centerIn: parent
            visible: configManager.currentScreen === "game"
        }
    }
}