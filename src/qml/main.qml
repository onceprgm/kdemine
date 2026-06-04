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

    property string activeTheme: configManager.activeTheme
    property string activeLanguage: configManager.activeLanguage
    property string currentScreen: "menu"

    property color backgroundColor: activeTheme === "classic" ? "#c0c0c0" : "#16161e"
    property color panelColor: activeTheme === "classic" ? "#c0c0c0" : "#1e1e2a"
    property color textColor: activeTheme === "classic" ? "#000000" : "#ffffff"
    property color accentColor: activeTheme === "classic" ? "#000080" : "#d9534f"
    property int elementRadius: activeTheme === "classic" ? 0 : 6

    property var translations: configManager.translations

    Rectangle {
        anchors.fill: parent
        color: mainWindow.backgroundColor
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

    Menu {
        id: contextMenu
        
        MenuItem {
            text: (configManager.translations && configManager.translations["abandon"]) || ""
            enabled: configManager.currentScreen === "game"
            onTriggered: configManager.currentScreen = "menu"
        }
        
        Menu {
            title: (configManager.translations && configManager.translations["theme"]) || ""
            MenuItem {
                text: "Breeze Dark"
                checkable: true
                checked: configManager.activeTheme === "breeze"
                onTriggered: configManager.activeTheme = "breeze"
            }
            MenuItem {
                text: "Classic Retro"
                checkable: true
                checked: configManager.activeTheme === "classic"
                onTriggered: configManager.activeTheme = "classic"
            }
        }

        Menu {
            title: (configManager.translations && configManager.translations["lang"]) || ""
            MenuItem {
                text: "English"
                checkable: true
                checked: configManager.activeLanguage === "en"
                onTriggered: configManager.activeLanguage = "en"
            }
            MenuItem {
                text: "Русский"
                checkable: true
                checked: configManager.activeLanguage === "ru"
                onTriggered: configManager.activeLanguage = "ru"
            }
            MenuItem {
                text: "中文"
                checkable: true
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

    Component.onCompleted: {
        var sysLang = Qt.locale().name.substring(0, 2);
        if (sysLang === "ru") {
            activeLanguage = "ru";
        } else if (sysLang === "zh") {
            activeLanguage = "zh";
        } else {
            activeLanguage = "en";
        }
    }
}