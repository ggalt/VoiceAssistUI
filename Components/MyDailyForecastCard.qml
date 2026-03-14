import QtQuick
import QtQuick.Layouts
import "../helper_functions.js" as Helpers

Item {
    implicitWidth: 324
    implicitHeight: 480
    width: implicitWidth
    height: implicitHeight

    property alias dayName: dailyForecastCard.dayName
    property alias weatherType: dailyForecastCard.weatherType
    property alias temperatureUnit: dailyForecastCard.temperatureUnit
    property alias tempHi: dailyForecastCard.tempHi
    property alias tempLo: dailyForecastCard.tempLo
    property alias precipPercent: dailyForecastCard.precipPercent
    property alias precipAmount: dailyForecastCard.precipAmount
    property alias precipUnit: dailyForecastCard.precipUnit

    Rectangle {
        id: dailyForecastCard
        anchors.fill: parent
        anchors.bottomMargin: height * 0.05
        color: "#00ffffff"
        property string dayName: ""
        property string weatherType: ""
        property string temperatureUnit: "\u00B0" + "F"
        property string tempHi: ""
        property string tempLo: ""
        property string precipPercent: ""
        property string precipAmount: ""
        property string precipUnit: ""


        ColumnLayout {
            anchors.fill: parent
            Text {
                id: txtDay
                text: qsTr(dailyForecastCard.dayName)
                font: Constants.smallFont
                horizontalAlignment: Text.AlignHCenter
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: parent.height * 0.15
            }
            Image {
                id: imgWeather
                source: dailyForecastCard.weatherType
                Layout.preferredHeight: parent.height * 0.15
                Layout.alignment: Qt.AlignHCenter
                width: height
                fillMode: Image.PreserveAspectFit
            }
            Text {
                id: txtPrecipPercent
                text: dailyForecastCard.precipPercent+"%"
                font: Constants.smallFont
                horizontalAlignment: Text.AlignHCenter
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: parent.height * 0.15
            }
            Text {
                id: txtPrecipAmount
                text: dailyForecastCard.precipAmount+" "+dailyForecastCard.precipUnit
                font: Constants.smallFont
                horizontalAlignment: Text.AlignHCenter
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: parent.height * 0.15
            }
            Text {
                id: txtHiTemp
                text: dailyForecastCard.tempHi + dailyForecastCard.temperatureUnit
                font: Constants.smallFont
                horizontalAlignment: Text.AlignHCenter
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: parent.height * 0.15
            }
            Text {
                id: txtLoTemp
                text: dailyForecastCard.tempLo + dailyForecastCard.temperatureUnit
                font: Constants.smallFont
                horizontalAlignment: Text.AlignHCenter
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: parent.height * 0.15
            }
        }
    }
}
