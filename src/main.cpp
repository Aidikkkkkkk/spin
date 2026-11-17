#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "controller/wawecontroller.h"

int main(int argc, char* argv[]) {
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    WaweController waweController;
    engine.rootContext()->setContextProperty("coord", &waweController);
    engine.loadFromModule("OneSpinModule", "Main");

    return app.exec();
}
