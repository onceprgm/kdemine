qt_add_executable(kdemine
    main.cpp
)

qt_add_qml_module(kdemine
    URI kdemine
    VERSION 1.0
    QML_FILES
        qml/main.qml
)

target_link_libraries(kdemine PRIVATE
    Qt6::Core
    Qt6::Quick
    Qt6::Qml
)