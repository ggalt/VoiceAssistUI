import QtQuick
import "../helper_functions.js" as Helpers

// Reusable digital-clock display with a blinking colon.
//
// Format tokens (see Helpers.formatClockTime):
//   HH / H  = 24-hour (zero-padded / unpadded)
//   hh / h  = 12-hour (zero-padded / unpadded)
//   mm / m  = minutes (zero-padded / unpadded)
//   MM / M  = same as mm / m
// Any literal ":" in the format blinks once per second when blinkColon is true.
//
// The AM/PM period is rendered in a separate Text so it can have its own
// font size and color (set showPeriod: true to display it).
//
// Example:
//   DigitalClock {
//       timeFormat: "hh:mm"
//       showPeriod: true
//       timePixelSize: 64
//       periodPixelSize: 24
//       timeColor: "#5d0000"
//   }
Item {
    id: root

    // --- Public API ---

    property string timeFormat: "hh:mm"
    property bool showPeriod: false
    property bool blinkColon: true

    property color timeColor: "white"
    property color periodColor: timeColor

    property real timePixelSize: 48
    property real periodPixelSize: timePixelSize * 0.5

    // Gap between the time text and the AM/PM text (pixels).
    property real periodSpacing: 6

    // Horizontal alignment of the clock content within this item's width.
    // Use Text.AlignLeft, Text.AlignHCenter, or Text.AlignRight.
    property int horizontalAlignment: Text.AlignHCenter

    // Aliases for full customization (font family/weight, fontSizeMode, ...).
    property alias timeText: timeText
    property alias periodText: periodText

    implicitWidth: contentRow.implicitWidth
    implicitHeight: contentRow.implicitHeight

    // --- Internal ---

    property bool _colonOn: true

    function _refresh() {
        var parts = Helpers.formatClockTime(root.timeFormat,
                                            root.blinkColon ? root._colonOn : true);
        timeText.text = parts.time;
        periodText.text = parts.period;
    }

    Timer {
        id: clockTimer
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            root._colonOn = !root._colonOn;
            root._refresh();
        }
    }

    onTimeFormatChanged: _refresh()
    onBlinkColonChanged: _refresh()

    Row {
        id: contentRow
        spacing: root.periodSpacing
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: root.horizontalAlignment === Text.AlignLeft ? parent.left : undefined
        anchors.right: root.horizontalAlignment === Text.AlignRight ? parent.right : undefined
        anchors.horizontalCenter: root.horizontalAlignment === Text.AlignHCenter ? parent.horizontalCenter : undefined

        Text {
            id: timeText
            color: root.timeColor
            font.pixelSize: root.timePixelSize
            verticalAlignment: Text.AlignVCenter
        }

        Text {
            id: periodText
            visible: root.showPeriod
            color: root.periodColor
            font.pixelSize: root.periodPixelSize
            // Match the time text's height so AlignVCenter lines the period
            // up with the middle of the (taller) time glyphs.
            height: timeText.height
            verticalAlignment: Text.AlignVCenter
        }
    }
}
