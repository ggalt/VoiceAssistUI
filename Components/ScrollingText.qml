import QtQuick

Rectangle {
    id: root
    clip: true
    color: "transparent"

    property real scrollSpeed: 50       // pixels per second
    property int scrollInterval: 3000   // ms to display static text before scrolling

    property alias scrollText: textPrimary.text
    property alias scrollFont: textPrimary.font
    property alias scrollFontPointSize: textPrimary.font.pointSize
    property alias scrollTextColor: textPrimary.color
    property alias scrollTextOpacity: textPrimary.opacity

    readonly property real _gap: Math.max(width * 0.10, 20)

    Item {
        id: scrollContainer
        x: 0
        height: parent.height

        Text {
            id: textPrimary
            text: ""
            color: "black"
            opacity: 1.0
            height: parent.height
            verticalAlignment: Text.AlignVCenter
        }

        Text {
            id: textWrap
            text: textPrimary.text
            font: textPrimary.font
            color: textPrimary.color
            opacity: textPrimary.opacity
            height: parent.height
            verticalAlignment: Text.AlignVCenter
            x: textPrimary.implicitWidth + root._gap
            visible: textPrimary.implicitWidth > root.width && root.width > 0
        }
    }

    NumberAnimation {
        id: scrollAnimation
        target: scrollContainer
        property: "x"
        onFinished: {
            scrollContainer.x = 0
            pauseTimer.start()
        }
    }

    Timer {
        id: pauseTimer
        interval: root.scrollInterval
        onTriggered: _startScrolling()
    }

    Component.onCompleted: _setup()
    onScrollTextChanged: _setup()
    onWidthChanged: _setup()

    function _startScrolling() {
        var textWidth = textPrimary.implicitWidth
        if (textWidth <= root.width || root.width <= 0) return
        var totalDistance = textWidth + _gap
        scrollAnimation.from = 0
        scrollAnimation.to = -totalDistance
        scrollAnimation.duration = totalDistance / scrollSpeed * 1000
        scrollAnimation.start()
    }

    function _setup() {
        scrollAnimation.stop()
        pauseTimer.stop()
        var textWidth = textPrimary.implicitWidth
        if (textWidth > root.width && root.width > 0) {
            scrollContainer.x = 0
            pauseTimer.start()
        } else {
            // Center text when it fits
            scrollContainer.x = Math.max(0, (root.width - textWidth) / 2)
        }
    }
}
