#pragma once

#include <QObject>
#include <QVariantMap>

class WaweController : public QObject {
    Q_OBJECT
   public:
    explicit WaweController(QObject* parent = nullptr);

    Q_INVOKABLE QVariantMap getWaweCoordinats(const QVariantMap& params);
};
