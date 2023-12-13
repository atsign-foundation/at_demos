import QtQuick
import QtQuick.Controls

Item {
    id: root

    //    property alias model: repeater.model
    property alias swipeView: swipeView
    property alias previousItem: previousItem
    property alias nextItem: nextItem

    required property int delegatePreferredHeight
    required property int delegatePreferredWidth

    ListView {
        id: roomSelector

        model: root.model
        orientation: ListView.Horizontal
        width: parent.width
        height: 28
        spacing: 26
        delegate: Label {
            id: labelDelegate

            text: modelData
            font.pixelSize: 12
            font.family: "Titillium Web"
            font.weight: 400
            font.bold: swipeView.currentIndex === index
            font.underline: swipeView.currentIndex === index
            color: swipeView.currentIndex === index ? "#2CDE85" : "#898989"

            MouseArea {
                anchors.fill: parent
                Connections {
                    function onClicked() {
                        swipeView.setCurrentIndex(labelDelegate.index)
                    }
                }
            }
        }
    }

    Image {
        source: "Images/arrow.svg"
        sourceSize.width: 35
        sourceSize.height: 35
        anchors.verticalCenter: swipeView.verticalCenter
        anchors.right: swipeView.left
        mirror: true

        TapHandler {
            id: previousItem
        }
    }

    Image {
        source: "Images/arrow.svg"
        anchors.verticalCenter: swipeView.verticalCenter
        anchors.left: swipeView.right
        sourceSize.width: 35
        sourceSize.height: 35

        TapHandler {
            id: nextItem
        }
    }

    SwipeView {
        id: swipeView

        height: root.delegatePreferredHeight
        width: root.delegatePreferredWidth

        anchors.top: roomSelector.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 4

        spacing: 7
        clip: true

        Repeater {
            id: repeater
            model: Object.keys(MyMonitor.model)
            delegate: DataTile {
                id: roomItem
                name: modelData
                height: root.delegatePreferredHeight
                width: root.delegatePreferredWidth
            }
        }
    }
}
