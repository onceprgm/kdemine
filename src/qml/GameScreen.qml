import QtQuick
import QtQuick.Controls

Column {
    id: gameScreen
    spacing: 16
    anchors.centerIn: parent

    property int maxGridWidth: mainWindow.width - 48
    property int maxGridHeight: mainWindow.height - 180

    property int cellSpacing: configManager.activeTheme === "classic" ? 0 : 2
    property int maxCellSize: configManager.activeTheme === "classic" ? 24 : 28

    property int calculatedCellSize: {
        var r = gameEngine.board.rows
        var c = gameEngine.board.cols
        if (r <= 0 || c <= 0) return maxCellSize

        var wLimit = (maxGridWidth - (c - 1) * cellSpacing) / c
        var hLimit = (maxGridHeight - (r - 1) * cellSpacing) / r

        var size = Math.min(wLimit, hLimit)
        return Math.min(maxCellSize, Math.max(12, Math.floor(size)))
    }

    Rectangle {
        width: Math.max(gridContainer.width, 300)
        height: 50
        color: configManager.panelColor
        radius: configManager.elementRadius
        anchors.horizontalCenter: parent.horizontalCenter
        border.width: configManager.activeTheme === "breeze" ? 1 : 0
        border.color: "#353547"

        Rectangle {
            visible: configManager.activeTheme === "classic"
            anchors.fill: parent
            color: "transparent"

            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 2
                color: "#808080"
            }
            Rectangle {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                width: 2
                color: "#808080"
            }
            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 2
                color: "#ffffff"
            }
            Rectangle {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 2
                color: "#ffffff"
            }
        }

        Text {
            id: mineText
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.verticalCenter: parent.verticalCenter
            text: {
                var mines = gameEngine.minesRemaining
                var label = (configManager.translations && configManager.translations["lang"] === "Language" ? "Mines: " : "Мины: ")
                return configManager.activeTheme === "classic" 
                    ? label + (mines < 100 ? (mines < 10 ? "00" + mines : "0" + mines) : mines)
                    : label + mines
            }
            color: configManager.textColor
            font.bold: true
            font.pixelSize: 15
            font.family: configManager.activeTheme === "classic" ? "Courier" : "sans-serif"
        }

        Button {
            id: restartBtn
            width: 36
            height: 36
            anchors.centerIn: parent
            
            contentItem: Text {
                text: {
                    if (configManager.activeTheme === "classic") {
                        if (gameEngine.gameState === "won") return "😎"
                        if (gameEngine.gameState === "lost") return "😵"
                        return "😊"
                    } else {
                        return "↻"
                    }
                }
                font.pixelSize: 18
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: configManager.textColor
            }

            background: Rectangle {
                color: restartBtn.down ? "#252533" : (restartBtn.hovered ? (configManager.activeTheme === "classic" ? "#b0b0b0" : "#2a2a3d") : configManager.panelColor)
                radius: configManager.elementRadius
                border.width: restartBtn.hovered ? (configManager.activeTheme === "classic" ? 0 : 1) : (configManager.activeTheme === "classic" ? 0 : 1)
                border.color: restartBtn.hovered ? configManager.accentColor : "#353547"

                Rectangle {
                    visible: configManager.activeTheme === "classic"
                    anchors.fill: parent
                    color: "transparent"

                    Rectangle {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 2
                        color: restartBtn.down ? "#808080" : "#ffffff"
                    }
                    Rectangle {
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        width: 2
                        color: restartBtn.down ? "#808080" : "#ffffff"
                    }
                    Rectangle {
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 2
                        color: restartBtn.down ? "#ffffff" : "#808080"
                    }
                    Rectangle {
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: 2
                        color: restartBtn.down ? "#ffffff" : "#808080"
                    }
                }
            }

            onClicked: {
                gameEngine.startCustomGame(gameEngine.board.rows, gameEngine.board.cols, gameEngine.board.totalMines)
            }
        }

        Text {
            id: timeText
            anchors.right: parent.right
            anchors.rightMargin: 15
            anchors.verticalCenter: parent.verticalCenter
            text: {
                var t = gameEngine.elapsedTime
                var label = (configManager.translations && configManager.translations["lang"] === "Language" ? "Time: " : "Время: ")
                return configManager.activeTheme === "classic"
                    ? label + (t < 100 ? (t < 10 ? "00" + t : "0" + t) : t)
                    : label + t + "s"
            }
            color: configManager.textColor
            font.bold: true
            font.pixelSize: 15
            font.family: configManager.activeTheme === "classic" ? "Courier" : "sans-serif"
        }
    }

    Rectangle {
        id: gridContainer
        width: gridColumn.width + (configManager.activeTheme === "classic" ? 8 : 16)
        height: gridColumn.height + (configManager.activeTheme === "classic" ? 8 : 16)
        color: configManager.panelColor
        radius: configManager.elementRadius
        anchors.horizontalCenter: parent.horizontalCenter
        border.width: configManager.activeTheme === "breeze" ? 1 : 0
        border.color: "#353547"

        Rectangle {
            visible: configManager.activeTheme === "classic"
            anchors.fill: parent
            color: "transparent"

            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 2
                color: "#808080"
            }
            Rectangle {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                width: 2
                color: "#808080"
            }
            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 2
                color: "#ffffff"
            }
            Rectangle {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 2
                color: "#ffffff"
            }
        }

        Column {
            id: gridColumn
            anchors.centerIn: parent
            spacing: configManager.activeTheme === "classic" ? 0 : 2

            Repeater {
                model: gameEngine.board.rows
                delegate: Row {
                    property int rowIdx: index
                    spacing: configManager.activeTheme === "classic" ? 0 : 2

                    Repeater {
                        model: gameEngine.board.cols
                        delegate: CellWidget {
                            row: rowIdx
                            col: index
                        }
                    }
                }
            }
        }
    }

    MenuButton {
        text: (configManager.translations && configManager.translations["abandon"]) || ""
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: configManager.currentScreen = "menu"
    }
}