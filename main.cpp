#include <QGuiApplication>
#include <QLoggingCategory>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QScreen>

int main(int argc, char *argv[])
{
    qputenv("QML_XHR_ALLOW_FILE_READ", "1");
    QLoggingCategory::setFilterRules(
        "*.debug=false\n"
        "qml.debug=true");

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    QScreen *primaryScreen = app.primaryScreen();
    engine.rootContext()->setContextProperty("primaryScreenWidth", primaryScreen->geometry().width());
    engine.rootContext()->setContextProperty("primaryScreenHeight", primaryScreen->geometry().height());

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("VoiceAssistUI", "Main");

    return app.exec();
}
