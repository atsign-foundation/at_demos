import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Column {
    id: root

    property alias menuOptions: repeater.model
    leftPadding: internal.leftPadding
    spacing: internal.spacing

    Repeater {
        id: repeater
        model: menuOptions

        delegate: ItemDelegate {
            id: columnItem

            required property string name
            required property string view
            required property string iconSource
            readonly property bool active: Constants.currentView === columnItem.view

            width: column.width
            height: column.height

            background: Rectangle {
                color: active ? "#2CDE85" : "transparent"
                radius: 12
                anchors.fill: parent
                opacity: 0.1
            }

            Column {
                id: column
                padding: 0
                Item {
                    id: menuItem

                    width: internal.delegateWidth
                    height: internal.delegateHeight

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: internal.leftMargin
                        anchors.rightMargin: internal.rightMargin
                        spacing: 24

                        Item {
                            Layout.preferredWidth: internal.iconWidth
                            Layout.preferredHeight: internal.iconWidth
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                            Image {
                                id: icon

                                source: "Images/" + columnItem.iconSource
                                sourceSize.width: internal.iconWidth
                            }

                            MultiEffect {
                                anchors.fill: icon
                                source: icon
                                colorization: 1
                                colorizationColor: Constants.iconColor
                            }
                        }

                        Label {
                            id: menuItemName
                            text: name
                            font.family: "Titillium Web"
                            font.pixelSize: 18
                            font.weight: 600
                            Layout.fillWidth: true
                            visible: internal.isNameVisible
                            color: Constants.primaryTextColor
                        }

                        Image {
                            source: "Images/arrow.svg"
                            visible: !columnItem.active
                                     && internal.isNameVisible
                        }
                    }
                }

                ListView {
                    model: [qsTr("Dark/Light")]
                    width: internal.delegateWidth
                    height: 44
                    visible: (Constants.isBigDesktopLayout
                              || Constants.isSmallDesktopLayout)
                             && columnItem.active
                             && columnItem.view == "Settings"
                    delegate: Item {
                        id: themeItem
                        width: internal.delegateWidth
                        height: 44
                        RowLayout {
                            id: row

                            width: Constants.isBigDesktopLayout ? 190 : 18
                            spacing: 6
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter

                            //                            anchors.fill: parent
                            Image {
                                source: AppSettings.isDarkTheme ? "Images/sun" : "Images/moon"
                            }
                            Label {
                                text: "Switch to "
                                      + (AppSettings.isDarkTheme ? "Light Mode" : "Dark Mode")
                                Layout.fillWidth: true
                                color: Constants.primaryTextColor
                                visible: internal.isNameVisible
                            }
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                AppSettings.isDarkTheme = !AppSettings.isDarkTheme
                            }
                        }
                    }
                }

                ListView {
                    id: graphsListView
                    model: ListModel {
                        ListElement {
                            label: qsTr("Live")
                            selected: false
                        }
                        ListElement {
                            label: qsTr("Historical")
                            selected: false
                        }
                    }
                    width: internal.delegateWidth
                    height: 88
                    visible: (Constants.isBigDesktopLayout
                              || Constants.isSmallDesktopLayout)
                             && columnItem.active && columnItem.view == "Graphs"
                    delegate: Item {
                        id: graphTypeItem
                        width: internal.delegateWidth
                        height: 44
                        Rectangle {
                            id: selectedRect
                            anchors.fill: parent
                            radius: 12
                            opacity: 0.1
                            // if selected green if not red
                            color: if (AppSettings.isDarkTheme) {
                                       model.selected ? Qt.lighter(
                                                            "#2CDE85") : "#002125"
                                   } else {
                                       model.selected ? Qt.lighter(
                                                            "#2CDE85") : "#E6F5F0"
                                   }
                        }

                        RowLayout {
                            id: graphRowLayout

                            width: Constants.isBigDesktopLayout ? 190 : 18
                            spacing: 6
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter

                            //                            anchors.fill: parent
                            Image {
                                source: AppSettings.isDarkTheme ? "Images/sun" : "Images/moon"
                            }
                            Label {
                                text: label
                                Layout.fillWidth: true
                                color: Constants.primaryTextColor
                                visible: internal.isNameVisible
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                for (var i = 0; i < graphsListView.model.count; i++) {
                                    graphsListView.model.get(i).selected = false
                                }
                                model.selected = true
                            }
                        }
                    }
                }
            }

            Connections {
                function onClicked() {
                    if (columnItem.view != "Settings") {
                        if (Constants.currentView == "Settings") {
                            //stops replacing of the view if "Settings" was active
                            //and the currently displayed view was reselected.
                            switch (columnItem.view) {
                            case "Graphs":
                                if (!(stackView.currentItem instanceof Graphs))
                                    stackView.replace("Graphs.qml",
                                                      StackView.Immediate)
                                break
                            case "Stats":
                                if (!(stackView.currentItem instanceof Stats))
                                    stackView.replace("Stats.qml",
                                                      StackView.Immediate)
                                break
                            }
                        } else if (columnItem.view != Constants.currentView) {
                            stackView.replace(columnItem.view + ".qml",
                                              StackView.Immediate)
                        }
                    }
                    Constants.currentView = columnItem.view
                }
            }
        }
    }

    states: [
        State {
            name: "bigDesktop"
            when: Constants.isBigDesktopLayout
            PropertyChanges {
                target: internal
                delegateWidth: 290
                delegateHeight: 60
                iconWidth: 34
                isNameVisible: true
                leftMargin: 31
                rightMargin: 13
                leftPadding: 5
                spacing: 5
            }
        },
        State {
            name: "smallDesktop"
            when: Constants.isSmallDesktopLayout
            PropertyChanges {
                target: internal
                delegateWidth: 56
                delegateHeight: 56
                iconWidth: 34
                isNameVisible: false
                leftMargin: 0
                rightMargin: 0
                leftPadding: 5
                spacing: 5
            }
        },
        State {
            name: "small"
            when: Constants.isSmallLayout
            PropertyChanges {
                target: internal
                delegateWidth: 24
                delegateHeight: 24
                iconWidth: 24
                isNameVisible: false
                leftMargin: 0
                rightMargin: 0
                leftPadding: 6
                spacing: 12
            }
        }
    ]

    QtObject {
        id: internal

        property int delegateWidth: 290
        property int delegateHeight: 60
        property int iconWidth: 34
        property bool isNameVisible: true
        property int leftMargin: 5
        property int rightMargin: 13
        property int leftPadding: 5
        property int spacing: 5
    }
}
