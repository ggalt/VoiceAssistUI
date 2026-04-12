cmake_minimum_required(VERSION 3.16)

project(VoiceAssistUI VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick WebEngineQuick)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appVoiceAssistUI
    main.cpp
)

set_source_files_properties(Components/Constants.qml PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)

qt_add_qml_module(appVoiceAssistUI
    URI VoiceAssistUI
    QML_FILES
        Main.qml
        Components/MyDailyForecastCard.qml
        Components/DetailWeatherCard.qml
        Components/WeatherItemDetail.qml
        helper_functions.js
        Components/Constants.qml
        Components/MusicInterface.qml
        audioFunctions.js
        Components/DigitalClock.qml
        QML_FILES Components/ScrollingText.qml
)

qt6_add_resources(APP_RESOURCES Icons.qrc)
target_sources(appVoiceAssistUI PRIVATE ${APP_RESOURCES})

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appVoiceAssistUI PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appVoiceAssistUI
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appVoiceAssistUI
    PRIVATE Qt6::Quick Qt6::WebEngineQuick
)

include(GNUInstallDirs)
install(TARGETS appVoiceAssistUI
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
