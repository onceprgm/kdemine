import "."
import QtQuick
import QtQuick.Controls

Column {
    spacing: 16
    anchors.centerIn: parent

    property int maxMines: Math.min(99, (sliderRows.value * sliderCols.value) - 9)

    Text {
        text: (configManager.translations && configManager.translations["custom_title"]) || ""
        color: configManager.textColor
        font.pixelSize: 26
        font.bold: true
        font.family: configManager.activeTheme === "classic" ? Style.classicFont : Style.modernFont
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        bottomPadding: 15
    }

    Column {
        spacing: 8
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            text: ((configManager.translations && configManager.translations["rows"]) || "") + ": " + sliderRows.value
            color: configManager.textColor
            font.bold: true
            font.pixelSize: 14
            font.family: configManager.activeTheme === "classic" ? Style.classicFont : Style.modernFont
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Slider {
            id: sliderRows
            from: 8
            to: 30
            stepSize: 1
            value: 16
            width: 220
        }
    }

    Column {
        spacing: 8
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            text: ((configManager.translations && configManager.translations["cols"]) || "") + ": " + sliderCols.value
            color: configManager.textColor
            font.bold: true
            font.pixelSize: 14
            font.family: configManager.activeTheme === "classic" ? Style.classicFont : Style.modernFont
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Slider {
            id: sliderCols
            from: 8
            to: 24
            stepSize: 1
            value: 16
            width: 220
        }
    }

    Column {
        spacing: 8
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            text: ((configManager.translations && configManager.translations["theme"] === "UI Theme" ? "Mines" : "Мины") || "") + ": " + sliderMines.value
            color: configManager.textColor
            font.bold: true
            font.pixelSize: 14
            font.family: configManager.activeTheme === "classic" ? Style.classicFont : Style.modernFont
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Slider {
            id: sliderMines
            from: 10
            to: maxMines
            stepSize: 1
            value: 40
            width: 220
        }
    }

    Item {
        width: 1
        height: 20
    }

    MenuButton {
        text: (configManager.translations && configManager.translations["launch"]) || ""
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            gameEngine.startCustomGame(sliderRows.value, sliderCols.value, sliderMines.value)
            configManager.currentScreen = "game"
        }
    }

    MenuButton {
        text: (configManager.translations && configManager.translations["back"]) || ""
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: configManager.currentScreen = "difficulty"
    }
}