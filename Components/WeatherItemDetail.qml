import QtQuick
import "../helper_functions.js" as Helpers

Rectangle {
    id: detailCard
    property string txtTag: ""
    property string icon: ""
    property string iconSize: '60'
    property string myValue: ""
    Image {
        id: imgTag
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        // source: "/weather/images/clear_day.svg"
        source: Helpers.findWeatherIcon(icon,iconSize)
        height: parent.height
        width: parent.height
    }
    Text {
        id: txtLabel
        text: txtTag
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: imgTag.right
        height: parent.height
        width: (parent.width - parent.height)/2
        font.pointSize: 200
        fontSizeMode: Text.Fit
        minimumPointSize: 8
    }
    Text {
        id: txtValue
        text: myValue
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.left: txtLabel.right
        height: parent.height
        horizontalAlignment: Text.AlignRight
        font.pointSize: 200
        fontSizeMode: Text.Fit
        minimumPointSize: 8
    }
}
