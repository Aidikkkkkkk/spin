import QtQuick
import QtQuick.Controls

Button {
    id: control
    hoverEnabled: false
    width: 200
    height: 45
    opacity: enabled ? 1.0 : 0.4
    background: Rectangle {
        color: "#c7ecee"
        border.color: "#01a3a4"
        radius: 10
    }
    contentItem: Text {
        text: control.text
        color: "#01a3a4"
        font.family: "Verdana"
        font.pixelSize: 16
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
