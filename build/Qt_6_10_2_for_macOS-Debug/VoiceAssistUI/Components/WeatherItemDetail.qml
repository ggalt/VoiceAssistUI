import QtQuick
import "../helper_functions.js" as Helpers

Rectangle {
    id: detailCard
    property string txtTag: ""
    property string icon: ""
    property string myValue: ""
    Image {
        id: imgTag
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        // source: "/weather/images/clear_day.svg"
        source: Helpers.findIcon(icon,'large')
        height: parent.height
        width: parent.height
    }
    Text {
        id: txtLabel
        text: txtTag
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: imgTag.right
        height: parent.height
    }
    Text {
        id: txtValue
        text: myValue
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        height: parent.height
    }
}
