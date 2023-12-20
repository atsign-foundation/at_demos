import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import PlantMonitor

Pane {
    id: root

    property bool isSmallLayout: false
    property string name
    visible: name !== "Timestamp"
    width: internal.width
    height: internal.height

    topPadding: 12
    leftPadding: internal.leftPadding
    bottomPadding: 0
    rightPadding: 16

    background: Rectangle {
        radius: 12
        color: Constants.accentColor
    }

    RowLayout {
        id: header

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: internal.switchMargin
        //        anchors.topMargin: 15
        spacing: 8

        Item {
            Layout.preferredWidth: internal.iconSize
            Layout.preferredHeight: internal.iconSize
            Layout.alignment: Qt.AlignTop

            Image {
                id: icon
                source: getIcon(root.name)
                sourceSize.width: internal.iconSize
                sourceSize.height: internal.iconSize
            }

            MultiEffect {
                anchors.fill: icon
                source: icon
                colorization: 1
                colorizationColor: Constants.iconColor
            }
        }

        Column {
            id: dataColumn
            Layout.fillWidth: true

            Label {
                text: root.name
                font.pixelSize: internal.fontSize
                font.weight: 600
                font.family: "Liberation Mono"
                color: Constants.primaryTextColor
            }

            Label {
                id: currentValue
                text: "Current Value: " + (root.name === "Temperature" ? MyMonitor.notificationModel[root.name][0] : MyMonitor.notificationModel[root.name][0] + "%")
                font.pixelSize: internal.fontSize
                font.weight: 300
                font.family: "Liberation Mono"
                //top padding of 10
                topPadding: 20
                color: Constants.primaryTextColor
                //                //on component complete print done
                //                onTextChanged: {
                //                    // print the type of MyMonitor.model[root.name][0]
                //                    console.log(typeof MyMonitor.model[root.name][0])
                //                    //print the type of MyMonitor.model[root.name][0][0]
                //                    console.log(typeof MyMonitor.model[root.name][0][0])
                //                    //print the type of MyMonitor.model[root.name][0][1]
                //                    console.log(typeof MyMonitor.model[root.name][0][1])
                //                }
            }
            Label {
                text: "7 Day Average: "
                font.pixelSize: internal.fontSize
                font.family: "Liberation Mono"
                color: Constants.primaryTextColor
                topPadding: 10
            }

            Label {
                text: "30 Day Average: "
                font.pixelSize: internal.fontSize
                font.family: "Liberation Mono"
                color: Constants.primaryTextColor
                topPadding: 10
            }
        }
    }

    QtObject {
        id: internal

        property int width: 530
        property int height: 276
        property int rightMargin: 60
        property int leftPadding: 16
        property int titleSpacing: 8
        property int spacing: 16
        property int columnMargin: 7
        property int iconSize: 42
        property int switchMargin: 9
        property int fontSize: 32
    }

    states: [
        State {
            name: "desktopLayout"
            when: Constants.isBigDesktopLayout || Constants.isSmallDesktopLayout
            PropertyChanges {
                target: root
                isSmallLayout: false
            }
            PropertyChanges {
                target: internal
                width: 530
                height: 276
                rightMargin: 53
                leftPadding: 16
                spacing: 16
                titleSpacing: 8
                columnMargin: 7
                iconSize: 42
                fontSize: 24
                switchMargin: 9
            }
            //            StateChangeScript {
            //                script: console.log("DataTile entered desktopLayout")
            //            }
        },
        State {
            name: "mobileLayout"
            when: Constants.isMobileLayout
            PropertyChanges {
                target: internal
                width: 306
                height: 177
                rightMargin: 12
                leftPadding: 8
                spacing: 6
                titleSpacing: 4
                columnMargin: 17
                iconSize: 24
                fontSize: 24
                switchMargin: 2
            }
            PropertyChanges {
                target: root
                isSmallLayout: true
            }
            //            StateChangeScript {
            //                script: console.log("DataTile entered mobileLayout")
            //            }
        },
        State {
            name: "smallLayout"
            when: Constants.isSmallLayout
            PropertyChanges {
                target: root
                isSmallLayout: true
            }
            PropertyChanges {
                target: internal
                width: 340
                height: 177
                rightMargin: 34
                leftPadding: 8
                spacing: 3
                titleSpacing: 2
                columnMargin: 7
                iconSize: 24
                fontSize: 12
                switchMargin: 9
            }
            //            StateChangeScript {
            //                script: console.log("DataTile entered smallLayout")
            //            }
        }
    ]

    function getIcon(name) {
        //switch on name
        switch (name) {
        case "Humidity":
            return "Images/humidity.svg"
        case "Light Level":
            return "Images/sun.svg"
        case "Soil Moisture":
            return "Images/moisture.svg"
        case "Temperature":
            return "Images/thermometer.svg"
        case "Water Delivered":
            return "Images/watering-can.svg"
        case "Water Level":
            return "Images/water-tank.svg"
        }
    }
}
