import "."
import QtQuick

Item {
    id: logo
    width: 100
    height: 120

    Item {
        width: 100
        height: 100
        anchors.top: parent.top

        SequentialAnimation on scale {
            running: configManager.activeTheme === "breeze"
            loops: Animation.Infinite
            PropertyAnimation { to: 1.05; duration: 1500; easing.type: Easing.InOutQuad }
            PropertyAnimation { to: 0.95; duration: 1500; easing.type: Easing.InOutQuad }
        }

        Repeater {
            model: 8
            Rectangle {
                anchors.centerIn: parent
                width: configManager.activeTheme === "classic" ? 4 : 6
                height: configManager.activeTheme === "classic" ? 70 : 76
                color: configManager.activeTheme === "classic" ? "#000000" : "#242433"
                border.color: configManager.activeTheme === "classic" ? "transparent" : "#353547"
                border.width: configManager.activeTheme === "classic" ? 0 : 1
                radius: configManager.activeTheme === "classic" ? 0 : 2
                rotation: index * 45
                
                Rectangle {
                    visible: configManager.activeTheme === "classic"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    width: 8
                    height: 8
                    color: "#000000"
                }
                Rectangle {
                    visible: configManager.activeTheme === "classic"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    width: 8
                    height: 8
                    color: "#000000"
                }
            }
        }

        Rectangle {
            anchors.centerIn: parent
            width: 44
            height: 44
            radius: 22
            color: configManager.activeTheme === "classic" ? "#000000" : configManager.panelColor
            border.color: configManager.activeTheme === "classic" ? "transparent" : "#353547"
            border.width: configManager.activeTheme === "classic" ? 0 : 2

            Rectangle {
                anchors.centerIn: parent
                width: 10
                height: 10
                radius: configManager.activeTheme === "classic" ? 0 : 5
                color: configManager.activeTheme === "classic" ? "#ffffff" : configManager.accentColor
                anchors.verticalCenterOffset: configManager.activeTheme === "classic" ? -6 : 0
                anchors.horizontalCenterOffset: configManager.activeTheme === "classic" ? -6 : 0

                SequentialAnimation on opacity {
                    running: configManager.activeTheme === "breeze"
                    loops: Animation.Infinite
                    PropertyAnimation { to: 0.2; duration: 750 }
                    PropertyAnimation { to: 1.0; duration: 750 }
                }
            }
        }
    }
}