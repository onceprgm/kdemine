#include <QGuiApplication>
#include <QQmlApplicationEngine>

using namespace Qt::StringLiterals;

int main(int argc, char *argv[])
{
    // TODO: Parse CLI arguments for window manager widget mode

    QGuiApplication app(argc, argv);
    app.setOrganizationName("KDEMineProject");
    app.setApplicationName("kdemine");

    QQmlApplicationEngine engine;
    
    const QUrl url(u"qrc:/qt/qml/kdemine/qml/main.qml"_s);
    
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl) {
            QCoreApplication::exit(-1);
        }
    }, Qt::QueuedConnection);
    
    engine.load(url);

    return app.exec();
}