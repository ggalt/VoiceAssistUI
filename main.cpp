#include <QGuiApplication>
#include <QLoggingCategory>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QCursor>
#include <QScreen>
#include <QtWebEngineQuick>

int main(int argc, char *argv[])
{
    qputenv("QML_XHR_ALLOW_FILE_READ", "1");
    QLoggingCategory::setFilterRules(
        "*.debug=false\n"
        "qml.debug=true");

    QtWebEngineQuick::initialize();

    QGuiApplication app(argc, argv);
    app.setOverrideCursor(QCursor(Qt::BlankCursor));

    QQmlApplicationEngine engine;

    QScreen *primaryScreen = app.primaryScreen();
    engine.rootContext()->setContextProperty("primaryScreenWidth", primaryScreen->geometry().width());
    engine.rootContext()->setContextProperty("primaryScreenHeight", primaryScreen->geometry().height());
    engine.rootContext()->setContextProperty("applicationDirPath", app.applicationDirPath());

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("VoiceAssistUI", "Main");

    return app.exec();
}
