import QtQuick
import QtQuick.Controls
import QtQuick3D

Item {
    id: twoSpin
    anchors.fill: parent

    signal backRequested()

    property bool measured: false
    property bool measured2: false
    property var pos1: ["Z", "U"]
    property var pos2: ["Z", "D"]
    property real t2start: 0.0
    property real currentT: 0.0
    property real pUp2: 0.5

    property real stepTime: 0.02
    property int frameMs: 16
    property real simTime: 0.0

    function mirror(pos) {
        return [pos[0], pos[1] === "U" ? "D" : "U"];
    }

    function computeBoth(t) {
        twoSpin.currentT = t;
        spin1.computeAt(panel.bx, panel.by, panel.bz, t, twoSpin.pos1);
        spin2.computeAt(panel.bx, panel.by, panel.bz,
                        Math.max(0.0, t - twoSpin.t2start), twoSpin.pos2);
    }

    function measureFirst() {
        anim.stop();
        twoSpin.pos1 = panel.position;
        twoSpin.pos2 = twoSpin.mirror(panel.position);
        twoSpin.t2start = 0.0;
        twoSpin.measured = true;
        twoSpin.measured2 = false;
        twoSpin.simTime = 0.0;
        twoSpin.computeBoth(0.0);
    }

    function measureSecond() {
        anim.stop();
        let axis = panel.position[0];
        let m = axis === "X" ? Qt.vector3d(1, 0, 0)
              : axis === "Y" ? Qt.vector3d(0, 1, 0)
              :                Qt.vector3d(0, 0, 1);
        let v = spin2.spinPos.normalized();
        let p = (1 + v.dotProduct(m)) / 2;
        twoSpin.pUp2 = p;
        twoSpin.pos2 = [axis, Math.random() < p ? "U" : "D"];
        twoSpin.t2start = twoSpin.currentT;
        twoSpin.measured2 = true;
        twoSpin.computeBoth(twoSpin.currentT);
    }

    function resetPair() {
        anim.stop();
        twoSpin.measured = false;
        twoSpin.measured2 = false;
        twoSpin.t2start = 0.0;
    }

    function arrowText(pos) {
        return pos[0] + (pos[1] === "U" ? "↑" : "↓");
    }

    Timer {
        id: anim
        interval: twoSpin.frameMs
        repeat: true
        onTriggered: {
            if (twoSpin.simTime >= 100.0) {
                stop();
                return;
            }
            twoSpin.computeBoth(twoSpin.simTime);
            twoSpin.simTime += twoSpin.stepTime;
            panel.timeText = twoSpin.simTime.toFixed(2);
        }
    }

    View3D {
        anchors.fill: parent

        PerspectiveCamera {
            position: Qt.vector3d(340, 400, 800)
            clipNear: 1.0
            clipFar: 5000.0
        }

        DirectionalLight {
            eulerRotation: Qt.vector3d(-30, 45, 0)
        }

        BlochSphere {
            id: spin1
            position: Qt.vector3d(290, 400, 100)
            scale: Qt.vector3d(0.7, 0.7, 0.7)
            spinVisible: twoSpin.measured
            ballColor: twoSpin.measured ? "green" : "orange"
        }

        BlochSphere {
            id: spin2
            position: Qt.vector3d(710, 400, 100)
            scale: Qt.vector3d(0.7, 0.7, 0.7)
            spinVisible: twoSpin.measured
            ballColor: twoSpin.measured ? "green" : "orange"
        }
    }
    Text {
        x: 364 - width / 2
        y: 110
        text: "Спин 1"
        font { family: "Verdana"; pixelSize: 18 }
    }
    Text {
        x: 666 - width / 2
        y: 110
        text: "Спин 2"
        font { family: "Verdana"; pixelSize: 18 }
    }
    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: panel.width / 2
        y: 16
        spacing: 4

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            font { family: "Verdana"; pixelSize: 15 }
            text: twoSpin.measured
                  ? "Спин 1 измерен: " + twoSpin.arrowText(twoSpin.pos1)
                    + ", спин 2 сразу после: " + twoSpin.arrowText(twoSpin.mirror(twoSpin.pos1))
                  : "Запутаны: у каждого спина по отдельности направления нет"
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            visible: twoSpin.measured2
            font { family: "Verdana"; pixelSize: 15 }
            text: "Спин 2 измерен: " + twoSpin.arrowText(twoSpin.pos2)
                  + " (вероятность up была " + Math.round(twoSpin.pUp2 * 100) + "%)"
        }
    }
    Row {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 16
        x: panel.width + (parent.width - panel.width - width) / 2
        spacing: 10

        AppButton {
            width: 175
            text: "Измерить спин 1"
            onClicked: twoSpin.measureFirst()
        }
        AppButton {
            width: 175
            text: "Измерить спин 2"
            enabled: twoSpin.measured
            onClicked: twoSpin.measureSecond()
        }
        AppButton {
            width: 175
            text: "Сбросить"
            onClicked: twoSpin.resetPair()
        }
    }

    ControlPanel {
        id: panel
        onBackRequested: {
            anim.stop();
            twoSpin.backRequested();
        }

        AppButton {
            text: "Рассчитать положение"
            enabled: twoSpin.measured
            onClicked: {
                anim.stop();
                twoSpin.computeBoth(parseFloat(panel.timeText) || 0.0);
            }
        }

        AppButton {
            text: anim.running ? "Остановить цикл" : "Запустить цикл"
            enabled: twoSpin.measured
            onClicked: {
                if (anim.running) {
                    anim.stop();
                } else {
                    twoSpin.simTime = parseFloat(panel.timeText) || 0.0;
                    if (twoSpin.simTime >= 100.0)
                        twoSpin.simTime = 0.0;
                    anim.start();
                }
            }
        }
    }
}
