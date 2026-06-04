qt_add_executable(kdemine
    main.cpp
    ConfigManager.cpp
    ConfigManager.h
    engine/Cell.cpp
    engine/Cell.h
    engine/GameBoard.cpp
    engine/GameBoard.h
    engine/GameEngine.cpp
    engine/GameEngine.h
)

file(COPY qml/assets DESTINATION ${CMAKE_BINARY_DIR}/qml)

qt_add_qml_module(kdemine
    URI kdemine
    VERSION 1.0
    QML_FILES
        qml/main.qml
        qml/MenuButton.qml
        qml/MineLogo.qml
        qml/MainMenuScreen.qml
        qml/DifficultyScreen.qml
        qml/SettingsScreen.qml
        qml/GameScreen.qml
        qml/CellWidget.qml
        qml/CustomScreen.qml
    RESOURCES
        qml/assets/icon.png
        qml/lang/en.json
        qml/lang/ru.json
        qml/lang/zh.json
)

target_link_libraries(kdemine PRIVATE
    Qt6::Core
    Qt6::Quick
    Qt6::Qml
)