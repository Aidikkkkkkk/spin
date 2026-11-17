import QtQuick
import QtQuick3D
import QtQuick3D.Helpers

Node {
    id: bloch

    property vector3d spinPos: Qt.vector3d(0, 0, 0)
    property bool spinVisible: true
    property color ballColor: "green"

    eulerRotation: Qt.vector3d(0, -20, 0)

    function computeAt(bx, by, bz, t, position) {
        let c = coord.getWaweCoordinats({
            "bx": bx,
            "by": by,
            "bz": bz,
            "time": t,
            "position": position
        });
        if (c)
            bloch.spinPos = Qt.vector3d(c.x, c.y, c.z);
    }

    function rotationFromY(dir) {
        let up = Qt.vector3d(0, 1, 0);
        let d = up.dotProduct(dir);
        if (d > 0.999999)
            return Qt.quaternion(1, 0, 0, 0);
        if (d < -0.999999)
            return Qt.quaternion(0, 1, 0, 0);
        let axis = up.crossProduct(dir).normalized();
        let half = Math.acos(d) / 2;
        let s = Math.sin(half);
        return Qt.quaternion(Math.cos(half), axis.x * s, axis.y * s, axis.z * s);
    }
    Model {
        source: "#Cylinder"
        position: Qt.vector3d(0, 0, 0)
        eulerRotation.z: -90
        scale: Qt.vector3d(0.02, 1.5, 0.02)
        materials: [ PrincipledMaterial { baseColor: "black" } ]
    }
    Model {
        source: "#Cylinder"
        position: Qt.vector3d(0, 0, 0)
        scale: Qt.vector3d(0.02, 1.5, 0.02)
        materials: [ PrincipledMaterial { baseColor: "black" } ]
    }
    Model {
        source: "#Cylinder"
        position: Qt.vector3d(0, 0, 0)
        eulerRotation.x: -90
        scale: Qt.vector3d(0.02, 1.5, 0.02)
        materials: [ PrincipledMaterial { baseColor: "black" } ]
    }
    Model {
        geometry: SphereGeometry {
            radius: 180.0
            rings: 32
            segments: 64
        }
        materials: [
            PrincipledMaterial {
                baseColor: "white"
                opacity: 0.2
                alphaMode: PrincipledMaterial.Blend
            }
        ]
    }
    Model {
        geometry: SphereGeometry {
            radius: 32.0
            rings: 32
            segments: 64
        }
        materials: [
            PrincipledMaterial {
                baseColor: bloch.ballColor
                opacity: 0.6
                alphaMode: PrincipledMaterial.Blend
            }
        ]
    }
    Model {
        readonly property vector3d dir: bloch.spinPos.normalized()
        visible: bloch.spinVisible && bloch.spinPos.length() > 0.000001
        source: "#Cylinder"
        position: dir.times(150)
        rotation: bloch.rotationFromY(dir)
        scale: Qt.vector3d(0.02, 1.5, 0.02)
        materials: [ PrincipledMaterial { baseColor: "black" } ]
    }
}
