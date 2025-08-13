import QtQuick
import QtQuick.Controls

TabBar {
    id: root
    property alias menuOptions: repeater.model

    contentHeight: 56

    background: Rectangle {
        color: Constants.accentColor
        border.color: Constants.accentTextColor
        radius: 12
    }

    Repeater {
        id: repeater

        delegate: TabButton {
            id: menuItem

            required property string name
            required property string view
            required property string iconSource
            readonly property bool active: Constants.currentView == menuItem.view

            background: Rectangle {
                color: "transparent"
            }

            icon.width: 24
            icon.height: 24
            icon.source: "Images/" + menuItem.iconSource
            icon.color: menuItem.active ? "#2CDE85" : Constants.accentTextColor

            Connections {
                function onClicked() {
                    if (menuItem.view != "Settings"
                            && menuItem.view != Constants.currentView) {
                        stackView.replace(menuItem.view + ".qml",
                                          StackView.Immediate)
                    }
                    Constants.currentView = menuItem.view
                }
            }
        }
    }
}
