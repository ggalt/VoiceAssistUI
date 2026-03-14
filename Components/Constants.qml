pragma Singleton
import QtQuick

QtObject {
    // readonly property int screenWidth: primaryScreenWidth
    // readonly property int screenHeight: primaryScreenHeight
    readonly property int screenWidth: 800
    readonly property int screenHeight: 480

    readonly property font smallFont: ({
        family: "Arial",
        pointSize: 13,
        bold: true
    })
}
