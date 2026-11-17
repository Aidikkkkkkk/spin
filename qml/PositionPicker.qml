import QtQuick
import QtQuick.Controls

Column {
    id: picker
    property var position: group.checkedButton ? group.checkedButton.position : ["Z", "U"]

    spacing: 2

    ButtonGroup {
        id: group
    }

    Text {
        text: "Начальное положение"
        font.pixelSize: 16
    }

    Grid {
        columns: 2
        columnSpacing: 10
        rowSpacing: 0
        padding: 4

        Repeater {
            model: [
                { label: "X up",   pos: ["X", "U"] },
                { label: "X down", pos: ["X", "D"] },
                { label: "Y up",   pos: ["Y", "U"] },
                { label: "Y down", pos: ["Y", "D"] },
                { label: "Z up",   pos: ["Z", "U"] },
                { label: "Z down", pos: ["Z", "D"] }
            ]

            delegate: RadioButton {
                required property var modelData
                property var position: modelData.pos

                text: modelData.label
                checked: modelData.pos[0] === "Z" && modelData.pos[1] === "U"
                font { family: "Verdana"; pixelSize: 15 }
                ButtonGroup.group: group
            }
        }
    }
}
