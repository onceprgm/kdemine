import QtQuick
import QtQuick.Controls

Button {
    id: btn
    width: 220
    height: 42
    
    onPressed: {
        configManager.playSound("click.wav")
    }
    
    contentItem: Text {
        text: btn.text
        color: btn.enabled ? configManager.textColor : "#808080"
        font.pixelSize: 14
        font.bold: true
        font.family: configManager.activeTheme === "classic" ? "Courier" : "sans-serif"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    
    background: Rectangle {
        color: btn.enabled ? (btn.down ? "#252533" : (btn.hovered ? (configManager.activeTheme === "classic" ? "#b0b0b0" : "#2a2a3d") : configManager.panelColor)) : configManager.panelColor
        border.color: btn.enabled && btn.hovered ? configManager.accentColor : (configManager.activeTheme === "classic" ? "#ffffff" : "#353547")
        border.width: 1
        radius: configManager.elementRadius
        opacity: btn.enabled ? 1.0 : 0.5
        
        Rectangle {
            visible: configManager.activeTheme === "classic"
            anchors.fill: parent
            color: "transparent"

            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 2
                color: btn.down ? "#808080" : "#ffffff"
            }
            Rectangle {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                width: 2
                color: btn.down ? "#808080" : "#ffffff"
            }
            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 2
                color: btn.down ? "#ffffff" : "#808080"
            }
            Rectangle {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 2
                color: btn.down ? "#ffffff" : "#808080"
            }
        }
        
        Behavior on color { 
            enabled: configManager.activeTheme === "breeze" && btn.enabled
            ColorAnimation { duration: 100 } 
        }
        Behavior on border.color { 
            enabled: configManager.activeTheme === "breeze" && btn.enabled
            ColorAnimation { duration: 100 } 
        }
    }
}