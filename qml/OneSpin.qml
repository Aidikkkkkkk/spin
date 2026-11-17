import QtQuick
import QtQuick.Controls
import QtQuick3D

Item {
    id: oneSpin
    anchors.fill: parent

    signal backRequested()

    property real stepTime: 0.02
    property int frameMs: 16
    property real simTime: 0.0

    function computeAt(t) {
        spin.computeAt(panel.bx, panel.by, panel.bz, t, panel.position);
    }

    Timer {
        id: anim
        interval: oneSpin.frameMs
        repeat: true
        onTriggered: {
            if (oneSpin.simTime >= 100.0) {
                stop();
                return;
            }
            oneSpin.computeAt(oneSpin.simTime);
            oneSpin.simTime += oneSpin.stepTime;
            panel.timeText = oneSpin.simTime.toFixed(2);
        }
    }

    View3D {
        anchors.fill: parent

        PerspectiveCamera {
            position: Qt.vector3d(400, 300, 800)
            clipNear: 1.0
            clipFar: 5000.0
        }

        DirectionalLight {
            eulerRotation: Qt.vector3d(-30, 45, 0)
        }

        BlochSphere {
            id: spin
            position: Qt.vector3d(500, 400, 100)
        }
    }

    ControlPanel {
        id: panel
        onBackRequested: {
            anim.stop();
            oneSpin.backRequested();
        }

        AppButton {
            text: "Рассчитать положение"
            onClicked: {
                anim.stop();
                oneSpin.computeAt(parseFloat(panel.timeText) || 0.0);
            }
        }

        AppButton {
            text: anim.running ? "Остановить цикл" : "Запустить цикл"
            onClicked: {
                if (anim.running) {
                    anim.stop();
                } else {
                    oneSpin.simTime = parseFloat(panel.timeText) || 0.0;
                    if (oneSpin.simTime >= 100.0)
                        oneSpin.simTime = 0.0;
                    anim.start();
                }
            }
        }
    }
}
