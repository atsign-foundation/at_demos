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
        anchors.centerIn: parent
        contentItem: Text {
            color: AppSettings.isDarkTheme ? "#000000" : "#ffffff"
            text: "Feed Plant"
        }
        background: Rectangle {
            color: AppSettings.isDarkTheme ? "#ffffff" : "#000000"
        }
        onClicked: {
            MyMonitor.run_pump_for_seconds()
            enabled = false
            text = "Watering..."
            cooldown.start()
            rainRepeater.model = 30
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
            interval: 10000
            running: false
            repeat: false
            onTriggered: {
                console.log("timer finished")
                requestWaterButton.enabled = true
                requestWaterButton.text = "Feed Plant"
                requestWaterButton.opacity = 1
                rainRepeater.model = 0
            }
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
