import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects

Pane {
    id: root
    background: Rectangle {
        color: Constants.accentColor
    }
    Button {
        id: requestWaterButton
        property alias buttonText: buttonText.text
        anchors.centerIn: parent
        // width: parent.width / 5
        height: parent.height / 8

        contentItem: Text {
            id: buttonText
            color: "#ffffff"
            text: enabled ? "Water The Plant For " + waterLevelSlider.value + " Second"
                            + (waterLevelSlider.value > 1 ? "s" : "") : "Watering..."
            font.pixelSize: 24
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.centerIn: parent
        }

        background: Rectangle {
            color: "#FF5C35"
            radius: 5
        }
        onClicked: {
            MyMonitor.run_pump_for_seconds(waterLevelSlider.value)
            enabled = false

            cooldown.start()
            rainRepeater.model = 30
            waterLevelSlider.visible = false
        }

        // animation blink
        SequentialAnimation {
            id: blink
            loops: Animation.Infinite
            running: !requestWaterButton.enabled
            PauseAnimation {
                duration: 1000
            }
            PropertyAnimation {
                target: requestWaterButton
                property: "opacity"
                from: 1
                to: 0
                duration: 1000
            }
            PauseAnimation {
                duration: 1000
            }
            PropertyAnimation {
                target: requestWaterButton
                property: "opacity"
                from: 0
                to: 1
                duration: 1000
            }
        }

        Timer {
            id: cooldown
            // 8 second cooldown
            interval: 8000
            running: false
            repeat: false
            onTriggered: {
                requestWaterButton.enabled = true
                requestWaterButton.opacity = 1
                rainRepeater.model = 0
                waterLevelSlider.visible = true
            }
        }
    }

    // a slider that goes from 1 to 5
    Slider {
        id: waterLevelSlider

        anchors {
            top: requestWaterButton.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: requestWaterButton.height
        }
        width: requestWaterButton.width
        height: parent.height / 8
        from: 1
        to: 5
        stepSize: 1
        value: 3
        snapMode: Slider.SnapAlways

        background: Rectangle {
            x: waterLevelSlider.leftPadding
            y: waterLevelSlider.topPadding + waterLevelSlider.availableHeight / 2 - height / 2
            implicitWidth: 200
            implicitHeight: 4
            width: waterLevelSlider.availableWidth
            height: implicitHeight
            radius: 2
            color: "#bdbebf"

            Rectangle {
                width: waterLevelSlider.visualPosition * parent.width
                height: parent.height
                color: "blue"
                radius: 2
            }
        }

        handle: Rectangle {
            x: waterLevelSlider.leftPadding + waterLevelSlider.visualPosition
               * (waterLevelSlider.availableWidth - width)
            y: waterLevelSlider.topPadding + waterLevelSlider.availableHeight / 2 - height / 2
            implicitWidth: 26
            implicitHeight: 26
            radius: 13
            color: "#FF5C35"
            border.color: "#FF5C35"
        }
    }

    //rain animation
    Repeater {
        id: rainRepeater
        model: 0
        Rectangle {
            id: rain
            width: 100
            height: 100
            y: (Math.random() * 1000) - root.height * 2
            x: Math.random() * 1000
            color: "transparent"

            Item {
                Image {
                    id: rainImage
                    source: "Images/drop.svg"
                    anchors.centerIn: parent
                    opacity: 1
                    transformOrigin: Item.Center
                    transform: Rotation {
                        id: rainRotation
                        origin.x: rainImage.width / 2
                        origin.y: rainImage.height / 2
                        angle: 0
                    }

                    //animate the rain falling down the screen (y increases)
                    NumberAnimation {
                        id: rainAnimation
                        target: rain
                        property: "y"
                        from: rain.y
                        to: root.height
                        duration: Math.random() * 1000 + 1000
                        running: true
                        loops: Animation.Infinite
                    }
                }
                MultiEffect {
                    anchors.fill: rainImage
                    source: rainImage
                    colorization: 1
                    colorizationColor: Constants.iconColor
                }
            }
        }
    }
}
