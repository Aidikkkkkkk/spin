cmake_minimum_required(VERSION 3.19)
project(Spin LANGUAGES CXX)
# compiller c++

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
# version package c++

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
# create compile_command.json

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)
# install signals

find_package(Qt6 REQUIRED COMPONENTS Quick Quick3D)
qt_policy(SET QTP0001 NEW)
# stay components Quick/Widgets

qt_add_executable(Spin
   src/main.cpp
   src/core/calculate.cpp
   src/controller/wawecontroller.cpp
)
qt_add_qml_module(Spin
URI OneSpinModule
VERSION 1.0
QML_FILES
qml/Main.qml
qml/TwoSpin.qml
qml/OneSpin.qml
qml/AppButton.qml
qml/BlochSphere.qml
qml/ControlPanel.qml
qml/FieldRow.qml
qml/PositionPicker.qml
)

target_link_libraries(Spin PRIVATE Qt6::Quick Qt6::Quick3D)
# stay Widgets/Quick
set_target_properties(Spin PROPERTIES
    WIN32_EXECUTABLE TRUE
)
install(TARGETS Spin
    BUNDLE DESTINATION .
    RUNTIME DESTINATION bin
)

qt_generate_deploy_qml_app_script(
    TARGET Spin
    OUTPUT_SCRIPT deploy_script
    NO_UNSUPPORTED_PLATFORM_ERROR
)
install(SCRIPT ${deploy_script})
