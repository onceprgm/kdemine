#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include "ConfigManager.h"
#include "engine/GameEngine.h"

using namespace Qt::StringLiterals;

int main(int argc, char *argv[])
{
    // TODO: Parse CLI arguments for window manager widget mode

    QGuiApplication::setOrganizationName("KDEMineProject");
    QGuiApplication::setApplicationName("kdemine");
    QGuiApplication::setDesktopFileName("kdemine");
    QGuiApplication::setWindowIcon(QIcon(u"qrc:/qt/qml/kdemine/qml/assets/icon.png"_s));

    QGuiApplication app(argc, argv);

    ConfigManager configManager;
    GameEngine gameEngine;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("configManager", &configManager);
    engine.rootContext()->setContextProperty("gameEngine", &gameEngine);

    const QUrl url(u"qrc:/qt/qml/kdemine/qml/main.qml"_s);
    
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl) {
            QCoreApplication::exit(-1);
        }
    }, Qt::QueuedConnection);
    
    engine.load(url);

    return QGuiApplication::exec();
}