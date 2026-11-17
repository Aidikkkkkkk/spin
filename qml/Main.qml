pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls

Window {
    id: root
    width: 800
    height: 580
    visible: true
    title: "Spin In Magnetic field"
    color: "#A9A9A9"

    minimumWidth: 800
    minimumHeight: 580
    maximumWidth: 800
    maximumHeight: 580

    Loader {
        id: pageLoader
        anchors.fill: parent
        sourceComponent: menuPage
    }

    Connections {
        target: pageLoader.item
        ignoreUnknownSignals: true
        function onBackRequested() {
            pageLoader.sourceComponent = menuPage
        }
    }

    Component {
        id: menuPage

        Item {
            Column {
                anchors.centerIn: parent
                spacing: 32

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Спин в магнитном поле"
                    color: "black"
                    font.family: "Verdana"
                    font.pixelSize: 20
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 40

                    Column {
                        width: 300
                        spacing: 14

                        AppButton {
                            width: parent.width
                            text: "1 Спин"
                            onClicked: Qt.callLater(function () {
                                pageLoader.source = "OneSpin.qml"
                            })
                        }

                        Text {
                            width: parent.width
                            text: "Модель 1 спина направлена на демонстрацию спина в магнитном поле, на его прецессию в нём."
                            wrapMode: Text.WordWrap
                            horizontalAlignment: Text.AlignHCenter
                            color: "black"
                            font.family: "Verdana"
                            font.pixelSize: 14
                        }
                    }

                    Column {
                        width: 300
                        spacing: 14

                        AppButton {
                            width: parent.width
                            text: "2 Спина"
                            onClicked: Qt.callLater(function () {
                                pageLoader.source = "TwoSpin.qml"
                            })
                        }

                        Text {
                            width: parent.width
                            text: "Модель 2 спинов демонстрирует два спина, связанных запутанностью, в магнитном поле. Прецессия остаётся, суть в показе направлений начальных положений после измерения."
                            wrapMode: Text.WordWrap
                            horizontalAlignment: Text.AlignHCenter
                            color: "black"
                            font.family: "Verdana"
                            font.pixelSize: 14
                        }
                    }
                }
            }

            Text {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 24
                anchors.horizontalCenter: parent.horizontalCenter
                width: 640
                text: "Забавно наблюдать за такой моделью, но важно понимать: считать, что спин (электрона в том числе) — это настоящая стрелка, направленная куда-то в пространстве — грубейшее представление о реальности. То, что состояние спина удобно описывать точкой на единичной сфере, ещё не значит, что в природе есть такая стрелка."
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                color: "black"
                font.family: "Verdana"
                font.pixelSize: 14
            }
        }
    }
}
