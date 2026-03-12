#include <QGuiApplication>
#include <QLoggingCategory>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    qputenv("QML_XHR_ALLOW_FILE_READ", "1");
    // QLoggingCategory::setFilterRules(
    //     "*.debug=true\n"
    //     "qt.qml.binding.removal.info=false");

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("VoiceAssistUI", "Main");

    return app.exec();
}
