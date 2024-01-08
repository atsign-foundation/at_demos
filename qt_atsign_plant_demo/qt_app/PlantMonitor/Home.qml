// Copyright (C) 2023 The Qt Company Ltd.
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Page {
    id: root

    header: ToolBar {
        id: toolBar

        background: Rectangle {
            color: Constants.accentColor
        }

        RowLayout {
            anchors.fill: parent
            Image {
                id: qtLogo
                Layout.topMargin: 6
                Layout.bottomMargin: 6
                Layout.leftMargin: 38
                source: AppSettings.isDarkTheme ? "Images/Qt-logo-white" : "Images/Qt-logo-black"
                sourceSize.height: 50
            }

            Image {
                id: atsignLogo
                Layout.topMargin: 6
                Layout.bottomMargin: 6
                Layout.leftMargin: 38
                source: AppSettings.isDarkTheme ? "Images/atsign-logo-light" : "Images/atsign-logo-dark"
                sourceSize.height: 50
            }

            Item {
                Layout.fillWidth: true
            }

            Image {
                id: themeTapButton

                source: "Images/theme.svg"
                sourceSize.height: Constants.isSmallLayout ? 15 : 20
                sourceSize.width: Constants.isSmallLayout ? 15 : 20
                Layout.rightMargin: Constants.isSmallLayout ? 5 : 19
                visible: Constants.isSmallLayout || Constants.isMobileLayout

                TapHandler {
                    onTapped: AppSettings.isDarkTheme = !AppSettings.isDarkTheme
                }
            }
        }
    }

    background: Rectangle {
        color: Constants.accentColor
    }

    StackView {
        id: stackView
        anchors {
            left: sideMenu.right
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }

        initialItem: Stats {}
    }

    SideBar {
        id: sideMenu
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
            topMargin: 63
        }
        height: parent.height
        menuOptions: menuItems
    }

    BottomBar {
        id: bottomMenu

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        width: parent.width

        visible: false
        position: TabBar.Footer
        menuOptions: menuItems
    }

    ListModel {
        id: menuItems

        ListElement {
            name: qsTr("Home")
            view: "Stats"
            iconSource: "home.svg"
        }
        ListElement {
            name: qsTr("Graphs")
            view: "Graphs"
            iconSource: "stats.svg"
        }
        ListElement {
            name: qsTr("Water")
            view: "Water"
            iconSource: "watering-can.svg"
        }
        ListElement {
            name: qsTr("Settings")
            view: "Settings"
            iconSource: "settings.svg"
        }
        ListElement {
            name: qsTr("About")
            view: "About"
            iconSource: "question.svg"
        }
        ListElement {
            name: qsTr("Terminal")
            view: "Terminal"
            iconSource: "terminal.svg"
        }
    }

    states: [
        State {
            name: "mobileLayout"
            when: Constants.isMobileLayout

            PropertyChanges {
                target: sideMenu
                visible: false
            }
            PropertyChanges {
                target: bottomMenu
                visible: true
            }
            PropertyChanges {
                target: stackView
                anchors.leftMargin: 0
            }
            PropertyChanges {
                target: qtLogo
                Layout.leftMargin: 19
                sourceSize.height: 25
                Layout.topMargin: 7
                Layout.bottomMargin: 7
            }
            PropertyChanges {
                target: atsignLogo
                Layout.leftMargin: 19
                sourceSize.height: 25
                Layout.topMargin: 7
                Layout.bottomMargin: 7
            }
            PropertyChanges {
                target: toolBar
                height: 39
            }
            AnchorChanges {
                target: stackView
                anchors.left: parent.left
                anchors.bottom: bottomMenu.top
            }
            //            StateChangeScript {
            //                name: "enteringMobileLayout"
            //                script: console.log("entering mobileLayout state")
            //            }
        },
        State {
            name: "desktopLayout"
            when: Constants.isBigDesktopLayout || Constants.isSmallDesktopLayout

            PropertyChanges {
                target: sideMenu
                visible: true
                anchors.topMargin: 63
            }
            PropertyChanges {
                target: bottomMenu
                visible: false
            }
            PropertyChanges {
                target: stackView
                anchors.leftMargin: 5
            }
            PropertyChanges {
                target: qtLogo
                Layout.leftMargin: 38
                sourceSize.height: 50
                Layout.topMargin: 6
                Layout.bottomMargin: 6
            }
            PropertyChanges {
                target: atsignLogo
                Layout.leftMargin: 38
                sourceSize.height: 50
                Layout.topMargin: 6
                Layout.bottomMargin: 6
            }
            PropertyChanges {
                target: toolBar
                height: 56
            }
            AnchorChanges {
                target: stackView
                anchors.left: sideMenu.right
                anchors.bottom: parent.bottom
            }
        },
        State {
            name: "smallLayout"
            when: Constants.isSmallLayout

            PropertyChanges {
                target: sideMenu
                visible: true
                anchors.topMargin: 24
            }
            PropertyChanges {
                target: bottomMenu
                visible: false
            }
            PropertyChanges {
                target: stackView
                anchors.leftMargin: 5
            }
            PropertyChanges {
                target: qtLogo
                Layout.leftMargin: 5
                sourceSize.height: 18
                Layout.topMargin: 5
                Layout.bottomMargin: 0
            }
            PropertyChanges {
                target: atsignLogo
                Layout.leftMargin: 5
                sourceSize.height: 18
                Layout.topMargin: 5
                Layout.bottomMargin: 0
            }
            PropertyChanges {
                target: toolBar
                height: 24
            }
            AnchorChanges {
                target: stackView
                anchors.left: sideMenu.right
                anchors.bottom: parent.bottom
            }
            //            StateChangeScript {
            //                name: "enteringSmallLayout"
            //                script: console.log("entering smallLayout state")
            //            }
        }
    ]
}
