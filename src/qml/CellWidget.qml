import QtQuick
import QtQuick.Controls

Item {
    id: cellWidget
    property int row: 0
    property int col: 0

    property var cellData: null

    width: gameScreen.calculatedCellSize
    height: gameScreen.calculatedCellSize

    Connections {
        target: gameEngine.board
        function onBoardReset() {
            updateCellPointer()
        }
    }

    Component.onCompleted: {
        updateCellPointer()
    }

    function updateCellPointer() {
        cellData = gameEngine.board.getCell(row, col)
    }

    Rectangle {
        anchors.fill: parent
        color: {
            if (configManager.activeTheme === "classic") {
                return "#c0c0c0"
            } else {
                if (cellData && cellData.isRevealed) {
                    return cellData.isMine ? "#3a1616" : "#14141d"
                } else {
                    return mouseArea.containsMouse ? "#2a2a3d" : "#1e1e2a"
                }
            }
        }
        radius: configManager.elementRadius
        border.width: configManager.activeTheme === "classic" ? 0 : 1
        border.color: configManager.activeTheme === "classic" ? "transparent" : "#2e2e3a"

        Rectangle {
            visible: configManager.activeTheme === "classic"
            anchors.fill: parent
            color: "transparent"

            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 2
                color: (cellData && cellData.isRevealed) ? "#808080" : "#ffffff"
            }
            Rectangle {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                width: 2
                color: (cellData && cellData.isRevealed) ? "#808080" : "#ffffff"
            }
            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 2
                color: (cellData && cellData.isRevealed) ? "#ffffff" : "#808080"
            }
            Rectangle {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 2
                color: (cellData && cellData.isRevealed) ? "#ffffff" : "#808080"
            }
        }

        Text {
            id: numberText
            anchors.centerIn: parent
            visible: cellData && cellData.isRevealed && !cellData.isMine && cellData.adjacentMines > 0
            text: cellData ? cellData.adjacentMines : ""
            font.bold: true
            font.pixelSize: Math.max(8, gameScreen.calculatedCellSize - (configManager.activeTheme === "classic" ? 10 : 12))
            font.family: configManager.activeTheme === "classic" ? "Courier" : "sans-serif"
            color: {
                if (!cellData) return "#ffffff"
                switch (cellData.adjacentMines) {
                    case 1: return "#0000ff"
                    case 2: return "#008000"
                    case 3: return "#ff0000"
                    case 4: return "#000080"
                    case 5: return "#800000"
                    case 6: return "#008080"
                    case 7: return "#000000"
                    case 8: return "#808080"
                    default: return "#ffffff"
                }
            }
        }

        Item {
            id: classicMineIcon
            anchors.centerIn: parent
            width: gameScreen.calculatedCellSize * 0.8
            height: gameScreen.calculatedCellSize * 0.8
            visible: cellData && cellData.isRevealed && cellData.isMine && configManager.activeTheme === "classic"

            Repeater {
                model: 8
                Rectangle {
                    anchors.centerIn: parent
                    width: 2
                    height: gameScreen.calculatedCellSize * 0.65
                    color: "#000000"
                    rotation: index * 45
                    
                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        width: 4
                        height: 4
                        color: "#000000"
                    }
                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        width: 4
                        height: 4
                        color: "#000000"
                    }
                }
            }

            Rectangle {
                anchors.centerIn: parent
                width: gameScreen.calculatedCellSize * 0.4
                height: gameScreen.calculatedCellSize * 0.4
                radius: width / 2
                color: "#000000"

                Rectangle {
                    anchors.centerIn: parent
                    width: 3
                    height: 3
                    color: "#ffffff"
                    anchors.verticalCenterOffset: -1
                    anchors.horizontalCenterOffset: -1
                }
            }
        }

        Rectangle {
            id: breezeMineIcon
            anchors.centerIn: parent
            width: gameScreen.calculatedCellSize * 0.35
            height: gameScreen.calculatedCellSize * 0.35
            radius: width / 2
            color: configManager.accentColor
            visible: cellData && cellData.isRevealed && cellData.isMine && configManager.activeTheme === "breeze"
        }

        Item {
            id: classicFlagIcon
            anchors.centerIn: parent
            width: gameScreen.calculatedCellSize * 0.6
            height: gameScreen.calculatedCellSize * 0.6
            visible: cellData && !cellData.isRevealed && cellData.isFlagged && configManager.activeTheme === "classic"

            Rectangle {
                anchors.left: parent.left
                anchors.leftMargin: 3
                anchors.top: parent.top
                anchors.topMargin: 2
                width: 2
                height: 10
                color: "#000000"
            }

            Rectangle {
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.top: parent.top
                anchors.topMargin: 2
                width: 6
                height: 5
                color: "#ff0000"
            }

            Rectangle {
                anchors.left: parent.left
                anchors.leftMargin: 1
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 1
                width: 6
                height: 2
                color: "#000000"
            }
        }

        Rectangle {
            id: breezeFlagIcon
            anchors.centerIn: parent
            width: gameScreen.calculatedCellSize * 0.35
            height: gameScreen.calculatedCellSize * 0.35
            radius: 2
            color: "#ff4444"
            visible: cellData && !cellData.isRevealed && cellData.isFlagged && configManager.activeTheme === "breeze"
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            hoverEnabled: true
            onClicked: (mouse) => {
                if (mouse.button === Qt.LeftButton) {
                    gameEngine.revealCell(row, col)
                } else if (mouse.button === Qt.RightButton) {
                    gameEngine.flagCell(row, col)
                }
            }
        }
    }
}