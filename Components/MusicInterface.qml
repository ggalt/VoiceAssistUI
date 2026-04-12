import QtQuick
import QtQuick.Controls
import "../helper_functions.js" as Helpers
import "../audioFunctions.js" as Audio

Rectangle {
    id: rectangle
    width: Constants.width
    height: Constants.height

    property string iconSize: "60"
    property string currentMode: "stop"
    property int currentShuffle: 0
    property int currentRepeat: 0
    property bool volumeAdjusting: false

    function updateTemperature() {
        Helpers.loadWeatherData(applicationDirPath + "/data/openweathermap.json")
        var temp = Helpers.getWeatherValue("temperature")
        var unit = Helpers.getWeatherValue("temperature_unit")
        if (temp !== undefined) {
            txtTemp.text = Math.round(temp) + (unit ? unit : "\u00B0" + "F")
        }
    }

    function updateButtonIcons() {
        if (currentMode === "play") {
            btnPlay.icon.source = Helpers.findAudioIcon("pause", iconSize)
        } else {
            btnPlay.icon.source = Helpers.findAudioIcon("play_arrow", iconSize)
        }

        if (currentShuffle > 0) {
            btnShuffle.icon.source = Helpers.findAudioIcon("shuffle_on", iconSize)
        } else {
            btnShuffle.icon.source = Helpers.findAudioIcon("shuffle", iconSize)
        }

        if (currentRepeat === 1) {
            btnRepeat.icon.source = Helpers.findAudioIcon("repeat_one", iconSize)
        } else if (currentRepeat === 2) {
            btnRepeat.icon.source = Helpers.findAudioIcon("repeat_on", iconSize)
        } else {
            btnRepeat.icon.source = Helpers.findAudioIcon("repeat", iconSize)
        }
    }

    Timer {
        id: musicPollTimer
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            Audio.pollStatus(function (status) {
                txtTitle.scrollText = status.title
                txtArtist.scrollText = status.artist
                txtAlbum.scrollText = status.album

                if (status.coverArtUrl !== "") {
                    image.source = status.coverArtUrl
                } else {
                    image.source = Helpers.findAudioIcon("stop_circle", "400")
                }

                txtTimePlayed.text = Audio.formatTime(status.elapsed)
                var remaining = status.duration - status.elapsed
                txtTimeRemaining.text = "-" + Audio.formatTime(remaining > 0 ? remaining : 0)

                if (status.duration > 0) {
                    var fraction = status.elapsed / status.duration
                    scrubberTime.width = scrubberTrack.width * fraction
                } else {
                    scrubberTime.width = 0
                }

                if (!volumeAdjusting) {
                    sliderVolume.value = status.volume / 100.0
                }

                currentMode = status.mode
                currentShuffle = status.shuffle
                currentRepeat = status.repeat

                updateButtonIcons()
            })
            updateTemperature()
        }
    }

    // color: Constants.backgroundColor

    Image {
        id: image
        width: 250
        height: 250
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 10
        anchors.topMargin: 10
        source: Helpers.findAudioIcon("stop_circle", "400")
        // source: "qrc:/audio/images/400/stop_circle.png"
        fillMode: Image.PreserveAspectFit
    }

    Rectangle {
        id: rectButtons
        width: 250
        color: "#00ffffff"
        anchors.left: parent.left
        anchors.top: image.bottom
        anchors.bottom: parent.bottom
        anchors.leftMargin: 10
        anchors.topMargin: 10
        anchors.bottomMargin: 20

        Grid {
            id: grid
            anchors.fill: parent
            spacing: 5
            rows: 2
            columns: 3

            Button {
                id: btnRewind
                width: 80
                height: 80
                icon.source: Helpers.findAudioIcon("skip_previous", iconSize)
                icon.height: iconSize
                icon.width: iconSize
                display: AbstractButton.IconOnly
                highlighted: false
                flat: true
                onClicked: Audio.skipPrevious()
            }

            Button {
                id: btnPlay
                width: 80
                height: 80
                icon.source: Helpers.findAudioIcon("play_arrow", iconSize)
                icon.height: iconSize
                icon.width: iconSize
                display: AbstractButton.IconOnly
                highlighted: false
                flat: true
                onClicked: {
                    if (currentMode === "play") {
                        Audio.pause()
                    } else {
                        Audio.play()
                    }
                }
            }

            Button {
                id: btnForward
                width: 80
                height: 80
                icon.source: Helpers.findAudioIcon("skip_next", iconSize)
                icon.height: iconSize
                icon.width: iconSize
                display: AbstractButton.IconOnly
                highlighted: false
                flat: true
                onClicked: Audio.skipNext()
            }

            Button {
                id: btnShuffle
                width: 80
                height: 80
                icon.source: Helpers.findAudioIcon("shuffle", iconSize)
                icon.height: iconSize
                icon.width: iconSize
                display: AbstractButton.IconOnly
                highlighted: false
                flat: true
                onClicked: {
                    var newVal = (currentShuffle + 1) % 3
                    Audio.setShuffle(newVal)
                }
            }

            Button {
                id: button4
                width: 80
                height: 80
                icon.height: iconSize
                icon.width: iconSize
                display: AbstractButton.IconOnly
                highlighted: false
                flat: true
            }

            Button {
                id: btnRepeat
                width: 80
                height: 80
                icon.source: Helpers.findAudioIcon("repeat", iconSize)
                icon.height: iconSize
                icon.width: iconSize
                display: AbstractButton.IconOnly
                highlighted: false
                flat: true
                onClicked: {
                    var newVal = (currentRepeat + 1) % 3
                    Audio.setRepeat(newVal)
                }
            }
        }
    }

    Rectangle {
        id: rectInfo
        color: "#00ffffff"
        anchors.left: image.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: image.bottom
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: 10

        ScrollingText {
            id: txtTitle
            scrollText: qsTr("Text")
            height: parent.height * 0.4
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            anchors.topMargin: 10
            scrollFont.pixelSize: height * 0.6
        }

        ScrollingText {
            id: txtArtist
            scrollText: qsTr("Text")
            height: parent.height * 0.2
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: txtTitle.bottom
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            anchors.topMargin: 10
            scrollFont.pixelSize: height * 0.6
        }

        ScrollingText {
            id: txtAlbum
            scrollText: qsTr("Text")
            height: parent.height * 0.2
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: txtArtist.bottom
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            anchors.topMargin: 10
            scrollFont.pixelSize: height * 0.6
        }
    }

    Rectangle {
        id: rectSliders
        color: "#00ffffff"
        anchors.left: rectButtons.right
        anchors.right: parent.right
        anchors.top: rectInfo.bottom
        anchors.bottom: rectButtons.verticalCenter
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: 10

        Text {
            id: txtTimePlayed
            text: qsTr("00:00")
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 10
            anchors.topMargin: 10
            font.pixelSize: 12
        }

        Rectangle {
            id: scrubberTrack
            height: txtTimePlayed.height
            color: "#40808080"
            radius: height * 0.4
            anchors.left: txtTimePlayed.right
            anchors.right: txtTimeRemaining.left
            anchors.top: parent.top
            anchors.leftMargin: 5
            anchors.rightMargin: 5
            anchors.topMargin: 10

            Rectangle {
                id: scrubberTime
                height: parent.height
                width: 0
                color: "#0ffb00"
                radius: height * 0.4
                anchors.left: parent.left
                anchors.top: parent.top
            }
        }

        Text {
            id: txtTimeRemaining
            text: qsTr("-00:00")
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 10
            anchors.topMargin: 10
            font.pixelSize: 12
        }

        Slider {
            id: sliderVolume
            value: 0.5
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            anchors.bottomMargin: 10
            onPressedChanged: {
                volumeAdjusting = pressed
                if (!pressed) {
                    Audio.setVolume(Math.round(value * 100))
                }
            }
        }
    }

    Rectangle {
        id: rectTime
        color: "#00ffffff"
        anchors.left: rectButtons.right
        anchors.right: parent.right
        anchors.top: rectSliders.bottom
        anchors.bottom: parent.bottom
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: 10
        anchors.bottomMargin: 10

        DigitalClock {
            id: txtTime
            anchors.left: parent.left
            anchors.right: parent.horizontalCenter
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 5
            anchors.rightMargin: 5
            anchors.topMargin: 5
            anchors.bottomMargin: 5
            timeFormat: "hh:mm"
            showPeriod: true
            timeColor: 'black'
            timePixelSize: height * 0.6
            periodPixelSize: height * 0.3
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            id: txtTemp
            text: ""
            anchors.left: parent.horizontalCenter
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 5
            anchors.rightMargin: 5
            anchors.topMargin: 5
            anchors.bottomMargin: 5
            font.pixelSize: height * 0.6
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
        }
    }
}
