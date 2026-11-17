#include "wawecontroller.h"

#include <QVariantList>

#include "src/core/calculate.h"

WaweController::WaweController(QObject* parent) : QObject(parent) {
}
QVariantMap WaweController::getWaweCoordinats(const QVariantMap& params) {
    QVariantMap result;

    float bx = params["bx"].toFloat();
    float by = params["by"].toFloat();
    float bz = params["bz"].toFloat();
    float time = params["time"].toFloat();

    QVariantList posList = params["position"].toList();
    char namePosition = 'Z';
    char position = 'U';

    if (posList.size() >= 2) {
        namePosition = posList[0].toString().toUpper().toLatin1()[0];
        position = posList[1].toString().toUpper().toLatin1()[0];
    }

    Coordinats coords = waweFunction(bx, by, bz, time, namePosition, position);

    result["x"] = coords.x;
    result["y"] = coords.y;
    result["z"] = coords.z;

    return result;
}
