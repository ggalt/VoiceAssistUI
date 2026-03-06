import QtQuick

Rectangle {
    id: detailWeatherCard
    color: "#00ffffff"
    property string weatherType: "clear_day"
    property string temperatureUnit: "\u00B0" + "F"
    property string tempHi: "60"
    property string tempLo: ""
    property string tempCurrent: ""
    property string humidity: ""
    property string windSpeed: ""

    WeatherItemDetail {
        id: currentConditions
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height / 3
        icon: weatherType
    }

    // Rectangle {
    //     id: detailCard
    //     property string txtTag: ""
    //     property string icon: ""
    //     property string myValue: ""
    //     Image {
    //         id: imgTag
    //         anchors.verticalCenter: parent.verticalCenter
    //         anchors.left: parent.left
    //         source: icon
    //         height: parent.height
    //         width: parent.height
    //     }
    //     Text {
    //         id: txtLabel
    //         text: txtTag
    //         anchors.verticalCenter: parent.verticalCenter
    //         anchors.left: imgTag.right
    //     }
    //     Text {
    //         id: txtValue
    //         text: myValue
    //         anchors.verticalCenter: parent.verticalCenter
    //         anchors.right: parent.right
    //     }
    // }

}
