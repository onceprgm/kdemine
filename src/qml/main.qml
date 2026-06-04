import QtQuick
import QtQuick.Controls

Window {
    id: mainWindow
    width: 600
    height: 400
    minimumWidth: 400
    minimumHeight: 300
    visible: true
    title: "KDE Mine"

    color: "#1e1e24"

    // TODO: Connect C++ backend engine to the QML context

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        Text {
            id: placeholderText
            anchors.centerIn: parent
            text: "Game board (ready for engine integration)"
            color: "#5c5c70"
            font.pixelSize: 16
        }
    }
}