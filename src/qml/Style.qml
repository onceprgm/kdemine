pragma Singleton
import QtQuick

QtObject {
    readonly property string classicFont: "Courier"
    readonly property string modernFont: "sans-serif"

    readonly property int classicCellSize: 24
    readonly property int modernCellSize: 28
    readonly property int minCellSize: 12
    readonly property int gridMargin: 48
    readonly property int gridVerticalOffset: 180

    readonly property int classicFontOffset: 10
    readonly property int modernFontOffset: 12

    readonly property int restartBtnSize: 36
    readonly property int contextMenuIndicatorSize: 16
    readonly property int contextMenuIndicatorDotSize: 8
}