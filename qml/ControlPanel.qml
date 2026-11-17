import QtQuick
import QtQuick.Controls

Column {
    id: panel

    signal backRequested()

    property real bx: bxField.value
    property real by: byField.value
    property real bz: bzField.value
    property alias timeText: timeField.text
    property alias position: picker.position

    default property alias content: extra.data

    padding: 8
    spacing: 6

    AppButton {
        text: "Меню"
        onClicked: panel.backRequested()
    }

    FieldRow { id: bxField; label: "Bx" }
    FieldRow { id: byField; label: "By" }
    FieldRow { id: bzField; label: "Bz" }
    FieldRow { id: timeField; label: "Time" }

    PositionPicker { id: picker }

    Column {
        id: extra
        spacing: panel.spacing
    }
}
