import QtQuick
import QtQuick.Window
import QtWebEngine
import QtQuick.Controls
import QtQuick.Layouts
import "Components"
import "helper_functions.js" as Helpers


Window {
    id: mainWindow
    width: 800
    height: 480
    // width: constants.screenWidth
    // height: constants.screenHeight
    visible: true

    Timer {
        id: tickTock
        property bool showColon: true
        property int weatherCount: 0
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            digitalClock.text = Helpers.getTime("t0", showColon);
            digitalClockPeriod.text = Helpers.getTime("p", showColon)
            showColon = !showColon;
            weatherCount +=1;
            if( weatherCount > 300 ) {
                weatherToday.getNewWeather();
                weatherCount = 0;
            }
        }
    }

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

                MouseArea {
                    anchors.fill: parent
                    propagateComposedEvents: true

                    onDoubleClicked: function(mouse) {
                        var js = "var el = document.elementFromPoint(%1, %2);"
                            + "if (el) { el.dispatchEvent(new MouseEvent('click', "
                            + "{bubbles: true, cancelable: true, clientX: %1, clientY: %2})); }"
                        js = js.arg(mouse.x).arg(mouse.y);
                        console.log("jsClick:", js);
                        immichWebView.runJavaScript(js);
                    }
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
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                anchors.topMargin: 10
                height: parent.height *0.4
            }

            TabBar {
                id: forecastTabs
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: weatherToday.bottom
                // height: 30
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                anchors.topMargin: 10
                anchors.bottomMargin: 3

                TabButton {
                    text: qsTr("Daily")
                }
                TabButton {
                    text: qsTr("Hourly")
                }
            }

            StackLayout {
                currentIndex: forecastTabs.currentIndex
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: forecastTabs.bottom
                anchors.bottom: parent.bottom
                Flickable {
                    id: weatherDailyFlickable
                    clip: true
                    contentWidth: weatherRow.width
                    contentHeight: weatherRow.height

                    Row {
                        id: weatherRow
                        height: weatherDailyFlickable.height
                        spacing: 0

                        Repeater {
                            model: 8
                            MyDailyForecastCard {
                                width: weatherDailyFlickable.width / 5
                                height: weatherDailyFlickable.height
                            }
                        }
                    }
                }

                Flickable {
                    id: weatherHourlyFlickable
                    clip: true
                    contentWidth: weatherHourlyRow.width
                    contentHeight: weatherHourlyRow.height

                    Row {
                        id: weatherHourlyRow
                        height: weatherHourlyFlickable.height
                        spacing: 0

                        Repeater {
                            model: 8
                            MyDailyForecastCard {
                                width: weatherHourlyFlickable.width / 5
                                height: weatherHourlyFlickable.height
                            }
                        }
                    }
                }

            }
        }

        Item {
            id: nightClock
            property color dayClockBackground: "white"
            property color dayClockFace: "black"
            property color nightClockBackground: "black"
            property color nightClockFace: "#5d0000"
            property int clockOpacity: 1.0
            state: "night"
            Rectangle {
                id:backgroundColorRect
                anchors.fill: parent
                color: nightClock.dayClockBackground
                Text {
                    id: digitalClock
                    width: parent.width * 0.6
                    text: qsTr("00:00")
                    font.pointSize: 200
                    fontSizeMode: Text.HorizontalFit
                    minimumPointSize: 8
                    anchors.centerIn: parent
                    color: nightClock.dayClockFace
                    opacity: nightClock.clockOpacity
                }
                Text {
                    id: digitalClockPeriod
                    text: qsTr("AM")
                    font.pointSize: digitalClock.fontInfo.pointSize * 0.5
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: digitalClock.right
                    color: nightClock.dayClockFace
                    opacity: nightClock.clockOpacity
                }
            }
            states: [
                State {
                    name: "day"
                    PropertyChanges {
                        backgroundColorRect.color: nightClock.dayClockBackground
                        digitalClock.color: nightClock.dayClockFace
                        digitalClockPeriod.color: nightClock.dayClockFace
                    }
                },
                State {
                    name: "night"
                    PropertyChanges {
                        backgroundColorRect.color: nightClock.nightClockBackground
                        digitalClock.color: nightClock.nightClockFace
                        digitalClockPeriod.color: nightClock.nightClockFace
                    }
                }
            ]
        }
    }

    PageIndicator {
        id: indicator

        count: swipeView.count
        currentIndex: swipeView.currentIndex

        anchors.bottom: swipeView.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }

}
