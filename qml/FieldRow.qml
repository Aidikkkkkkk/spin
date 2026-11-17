import QtQuick
import QtQuick.Controls

Row {
    id: rowItem
    property alias label: caption.text
    property alias text: field.text
    readonly property real value: parseFloat(field.text) || 0.0
    padding: 4
    spacing: 10

    Text {
        id: caption
        font.pixelSize: 18
        anchors.verticalCenter: parent.verticalCenter
    }

    TextField {
        id: field
        width: 80
        height: 30
        text: "1.0"
        font.pixelSize: 16
        verticalAlignment: TextInput.AlignVCenter
    }
}
