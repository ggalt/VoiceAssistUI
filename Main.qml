import QtQuick
import QtQuick.Window
import QtWebEngine
import QtQuick.Controls


Window {
    width: 800
    height: 480
    visible: true

    SwipeView {
        id: swipeView

        currentIndex: 0
        anchors.fill: parent

        Item {
            Rectangle {
                anchors.fill: parent

                id: immichFrame
                WebEngineView {
                    id: immichWebView
                    anchors.fill: parent
                    url: "http://192.168.1.228:8080"
                    // Render-only mode so SwipeView can receive drag/touch input.
                    enabled: false
                }
            }

        }

        Item {
            id: weatherView
            DetailWeatherCard {
                id: weatherToday
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                height: parent.height / 2
            }

            Flickable {
                id: weatherFlickable
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: weatherToday.bottom
                anchors.bottom: parent.bottom
                clip: true
                contentWidth: weatherRow.width
                contentHeight: weatherRow.height

                Row {
                    id: weatherRow
                    height: weatherFlickable.height
                    spacing: 0

                    Repeater {
                        model: 8
                        MyDailyForecastCard {
                            width: weatherFlickable.width / 5
                            height: weatherFlickable.height
                        }
                    }
                }
            }
        }

        Item {
            id: nightClock
            Rectangle {
                id:backgroundColor
                anchors.fill: parent
                color: "black"
                Text {
                    id: digitalClock
                    text: qsTr("00:00 AM")
                    font.pointSize: 100
                    anchors.centerIn: parent
                    color: "red"
                }
            }

        }
        // onCurrentIndexChanged: immichWebView.reload()
    }

    PageIndicator {
        id: indicator

        count: swipeView.count
        currentIndex: swipeView.currentIndex

        anchors.bottom: swipeView.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
