import QtQuick
import QtQuick.Window 2.2

Item {
    id: constants
    property int screenWidth: ScreenInfo.width
    property int screenHeight: ScreenInfo.height

    readonly property font smallFont: ({
        family: "Arial",
        pointSize: 13,
        bold: true
    })
}
