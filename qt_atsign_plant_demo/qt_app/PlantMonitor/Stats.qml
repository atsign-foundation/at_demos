import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import PlantMonitor

Pane {
    id: root

    topPadding: 4
    leftPadding: 27
    rightPadding: 27
    bottomPadding: 13

    background: Rectangle {
        anchors.fill: parent
        color: Constants.backgroundColor
    }

    Column {
        id: title

        width: internal.contentWidth

        Label {
            id: heading

            text: qsTr("Welcome")
            font: Constants.desktopTitleFont
            color: Constants.primaryTextColor
            elide: Text.ElideRight
        }

        Label {
            id: heading2

            text: qsTr("Here's the list of your plant health data")
            font.pixelSize: 24
            font.weight: 600
            font.family: "Liberation Mono"
            color: Constants.accentTextColor
            elide: Text.ElideRight
        }
    }

    DataScrollView {
        id: scrollView

        anchors.top: title.bottom
        anchors.topMargin: 10

        width: internal.contentWidth
        height: internal.contentHeight
        gridWidth: internal.contentWidth
        gridHeight: internal.contentHeight

        delegatePreferredWidth: internal.delegatePreferredWidth
        delegatePreferredHeight: internal.delegatePreferredHeight

        columns: root.width < 1140 ? 1 : 2
    }

    DataSwipeView {
        id: swipeView

        anchors.top: title.bottom
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.right: parent.right

        width: internal.contentWidth
        height: internal.contentHeight
        delegatePreferredHeight: internal.delegatePreferredHeight
        delegatePreferredWidth: internal.delegatePreferredWidth
        visible: false
    }

    QtObject {
        id: internal

        readonly property int contentHeight: root.height - title.height
                                             - root.topPadding - root.bottomPadding
        readonly property int contentWidth: root.width - root.rightPadding - root.leftPadding
        property int delegatePreferredHeight: 276
        property int delegatePreferredWidth: 530
    }

    states: [
        State {
            name: "desktopLayout"
            when: Constants.isBigDesktopLayout || Constants.isSmallDesktopLayout
            PropertyChanges {
                target: heading
                text: qsTr("Welcome")
                font: Constants.desktopTitleFont
            }
            PropertyChanges {
                target: heading2
                visible: true
            }
            PropertyChanges {
                target: scrollView
                visible: true
            }
            PropertyChanges {
                target: swipeView
                visible: false
            }
            PropertyChanges {
                target: internal
                delegatePreferredHeight: 276
                delegatePreferredWidth: 530
            }
            PropertyChanges {
                target: root
                leftPadding: 27
            }
        },
        State {
            name: "mobileLayout"
            when: Constants.isMobileLayout
            PropertyChanges {
                target: heading
                text: qsTr("Plant Health Data")
                font: Constants.mobileTitleFont
            }
            PropertyChanges {
                target: heading2
                visible: false
            }
            PropertyChanges {
                target: scrollView
                visible: true
            }
            PropertyChanges {
                target: swipeView
                visible: false
            }
            PropertyChanges {
                target: internal
                delegatePreferredHeight: 177
                delegatePreferredWidth: 306
            }
            PropertyChanges {
                target: root
                leftPadding: 27
            }
        },
        State {
            name: "smallLayout"
            when: Constants.isSmallLayout
            PropertyChanges {
                target: heading
                text: qsTr("Plant Health Data")
                font: Constants.smallTitleFont
            }
            PropertyChanges {
                target: heading2
                visible: false
            }
            PropertyChanges {
                target: scrollView
                visible: false
            }
            PropertyChanges {
                target: swipeView
                visible: true
            }
            PropertyChanges {
                target: internal
                delegatePreferredHeight: 177
                delegatePreferredWidth: 340
            }
            PropertyChanges {
                target: root
                leftPadding: 11
            }
        }
    ]
}
