import QtQuick
import QtQuick.Layouts
import "../helper_functions.js" as Helpers

Rectangle {
    id: detailWeatherCard
    color: "#00ffffff"
    property string weatherType: ""
    property string temperatureUnit: "\u00B0" + "F"
    property string tempHi: "60"
    property string tempLo: ""
    property string tempCurrent: ""
    property string humidity: ""
    property string windSpeed: ""
    property int windDirection: 0
    property string windCompassDirection: ""
    property string windSpeedUnits: ""
    property string visibility: ""
    property string visibilityUnits: ""
    property string air_pressure: ""
    property string air_pressure_unit: ""

    Component.onCompleted: {
        getNewWeather();
    }

    function getNewWeather() {
        Helpers.loadWeatherData("/home/esp32Dev/projects/VoiceAssistUI/data/openweathermap.json");
        weatherType = Helpers.weatherStateToIcon(Helpers.getWeatherValue("state"));
        tempCurrent = Helpers.getWeatherValue("temperature");
        humidity = Helpers.getWeatherValue("humidity");
        windSpeed = Helpers.getWeatherValue("wind_speed");

        windDirection = Helpers.getWeatherValue("wind_bearing");
        windCompassDirection = Helpers.degreesToCompass(windDirection);
        windSpeedUnits = Helpers.getWeatherValue("wind_speed_unit");
        visibility = Helpers.getWeatherValue("visibility");
        visibilityUnits = Helpers.getWeatherValue("visibility_unit");
        air_pressure = Helpers.getWeatherValue("pressure");
        air_pressure_unit = Helpers.getWeatherValue("pressure_unit");
    }

    WeatherItemDetail {
        id: currentConditions
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height / 3
        icon: "sunny"
        // icon: weatherType
        iconSize: "100"
        txtTag: "Temp:"
        myValue: tempCurrent+temperatureUnit
    }

    ColumnLayout {
        id: weatherSubRect
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: currentConditions.bottom
        anchors.bottom: parent.bottom
        spacing: 2
        WeatherItemDetail {
            id: windSpeedDetail
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: parent.height/4
            icon: "wind"
            iconSize: "60"
            txtTag: "Wind:"
            myValue: windCompassDirection +" ("+ windDirection +"\u00B0) at "+ windSpeed +" "+ windSpeedUnits
        }
        WeatherItemDetail {
            id: visibilityDetail
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: parent.height/4
            icon: Helpers.weatherStateToIcon("visibility")
            iconSize: "60"
            txtTag: "Visibility:"
            myValue: visibility+" "+visibilityUnits
        }
        WeatherItemDetail {
            id: humidityDetail
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: parent.height/4
            icon: Helpers.weatherStateToIcon("humidity-percent")
            iconSize: "60"
            txtTag: "Humidity:"
            myValue: humidity+"%"
        }
        WeatherItemDetail {
            id: pressureDetail
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: parent.height/4
            icon: Helpers.weatherStateToIcon("humidity-percent")
            iconSize: "60"
            txtTag: "Barametric Pressure:"
            myValue: air_pressure+" "+air_pressure_unit
        }
    }
}
