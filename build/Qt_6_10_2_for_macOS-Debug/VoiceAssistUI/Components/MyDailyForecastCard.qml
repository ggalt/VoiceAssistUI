import QtQuick

Item {
    implicitWidth: 324
    implicitHeight: 480
    width: implicitWidth
    height: implicitHeight

    Rectangle {
        id: dailyForecastCard
        anchors.fill: parent
        color: "#00ffffff"
        property string dayName: "Mon"
        property string weatherType: ""
        property string temperatureUnit: "\u00B0" + "F"
        property string tempHi: "60"
        property string tempLo: ""
        Text {
            id: txtDay
            text: qsTr(parent.dayName)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            height: parent.height / 6
        }
        Image {
            id: imgWeather
            source: parent.weatherType
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: txtDay.bottom
            height: parent.height / 3
        }
        Text {
            id: txtHiTemp
            text: parent.tempHi + parent.temperatureUnit
            anchors.top: imgWeather.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.height / 4
        }
        Text {
            id: txtLoTemp
            text: qsTr(parent.tempLo + parent.temperatureUnit)
            anchors.top: txtHiTemp.bottom
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
