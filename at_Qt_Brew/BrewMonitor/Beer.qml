
/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import QtQuick.Layouts
import BeerTap

//this is a design studio file that should be refactored
Page {
    id: pane
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    width: Constants.width
    height: Constants.height - 50
    property color tileColor: "black"
    property color glowColor: "#55ff55" //add orange glow in light mode
    property real tileGlowRadius: 5
    property int beer1Count: 5
    property int beer2Count: 14
    property int selectedBeer: -1
    property int sizeSelected: 0
    property int displayCalories: 0
    property real displayABV: 0
    property int displayCount: 0
    property real displayFat: 0
    property real displayCholesterol: 0
    property real displaySodium: 0
    property real displayCarbs: 0
    property real displayProtein: 0

    Behavior on displayCalories {
        NumberAnimation {
            duration: 2000
            easing.type: Easing.InOutQuad
        }
    }
    Behavior on displayABV {
        NumberAnimation {
            duration: 2000
            easing.type: Easing.InOutQuad
        }
    }
    Behavior on displayCount {
        NumberAnimation {
            duration: 2000
            easing.type: Easing.InOutQuad
        }
    }
    Behavior on displayFat {
        NumberAnimation {
            duration: 2000
            easing.type: Easing.InOutQuad
        }
    }
    Behavior on displayCholesterol {
        NumberAnimation {
            duration: 2000
            easing.type: Easing.InOutQuad
        }
    }
    Behavior on displaySodium {
        NumberAnimation {
            duration: 2000
            easing.type: Easing.InOutQuad
        }
    }
    Behavior on displayCarbs {
        NumberAnimation {
            duration: 2000
            easing.type: Easing.InOutQuad
        }
    }
    Behavior on displayProtein {
        NumberAnimation {
            duration: 2000
            easing.type: Easing.InOutQuad
        }
    }

    Rectangle {
        id: background
        color: "#002125"
        anchors.fill: parent
    }

    RectangularGlow {
        id: nutritionInfoGlow
        cached: false
        anchors.fill: nutritionInfo
        glowRadius: tileGlowRadius
        spread: 0.1
        color: glowColor
        cornerRadius: nutritionInfo.radius + glowRadius
    }

    SequentialAnimation {
        id: tileGlowAnimation
        PropertyAnimation {
            id: tileGlowRadiusAnimationBrighten
            target: pane // Target the glow component
            property: "tileGlowRadius" // The property to animate
            from: 0 // Starting glow radius
            to: 5 // Ending glow radius
            duration: 3500 // Duration of the animation in milliseconds
            // loops: Animation.Infinite // Loop indefinitely
            easing.type: Easing.InOutSine // Smooth easing for a more natural effect

            running: true // Start the animation immediately
        }
        PropertyAnimation {
            id: tileGlowRadiusAnimationDim
            target: pane // Target the glow component
            property: "tileGlowRadius" // The property to animate
            from: 5 // Starting glow radius
            to: 0 // Ending glow radius
            duration: 3500 // Duration of the animation in milliseconds
            /*    loops: Animation.Infinite*/ // Loop indefinitely
            easing.type: Easing.InOutSine // Smooth easing for a more natural effect

            running: true // Start the animation immediately
        }
        loops: Animation.Infinite
        running: true
    }

    Rectangle {
        id: nutritionInfo
        // calories
        x: 40
        y: 240
        width: 150
        height: 211
        color: tileColor
        radius: 25

        Text {
            id: nutritionText
            text: "Nutrition Info"
            font.pointSize: 14
            width: contentWidth
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#FFFFFF"
        }

        GridLayout {
            anchors.top: nutritionText.bottom
            anchors.bottom: parent.bottom
            columns: 2
            rows: 5
            columnSpacing: 20
            rowSpacing: 0

            Text {
                text: "Total Fat"
                color: "#FFFFFF"
                Layout.leftMargin: 15
            }
            Text {
                text: Math.round(displayFat * 10) / 10 + "g"
                color: "#FFFFFF"
            }

            Text {
                text: "Cholesterol"
                color: "#FFFFFF"
                Layout.leftMargin: 15
            }
            Text {
                text: Math.round(displayCholesterol * 10) / 10 + "g"
                color: "#FFFFFF"
            }

            Text {
                text: "Sodium"
                color: "#FFFFFF"
                Layout.leftMargin: 15
            }
            Text {
                text: Math.round(displaySodium * 10) / 10 + "g"
                color: "#FFFFFF"
            }

            Text {
                text: "Total Carbs"
                color: "#FFFFFF"
                Layout.leftMargin: 15
            }
            Text {
                text: Math.round(displayCarbs * 10) / 10 + "g"
                color: "#FFFFFF"
            }

            Text {
                text: "Protein"
                color: "#FFFFFF"
                Layout.leftMargin: 15
            }
            Text {
                text: Math.round(displayProtein * 10) / 10 + "g"
                color: "#FFFFFF"
            }
        }
    }

    RectangularGlow {
        id: beer1Glow
        anchors.fill: beer1
        glowRadius: tileGlowRadius
        spread: 0.1
        color: "white"
        cornerRadius: beer1.radius + glowRadius
        visible: selectedBeer === 0 || selectedBeer === -1
    }

    RoundButton {
        id: beer1
        radius: 25
        anchors.centerIn: parent
        width: 180
        height: 260
        anchors.verticalCenterOffset: -100
        anchors.horizontalCenterOffset: -125
        // opacity: selectedBeer === 0 ? 1 : 0.5
        property int calories: 173
        property real abv: 4.8
        property real fat: 0
        property real cholesterol: 0
        property real sodium: 0.011
        property real carbs: 11
        property real protein: 1

        Image {
            id: beer1Image
            // anchors.fill:parent
            source: "Images/Budweiser.png"
            // sourceSize.width: parent.width
            // sourceSize.height: 100
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 30
            scale: .175
        }
        Glow {
            anchors.fill: beer1Image
            source: beer1Image
            radius: 25
            spread: 0.2
            color: "white"
            scale: beer1Image.scale
        }

        Text {
            text: "Budweiser"
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 16
            color: "#FFFFFF"
        }

        background: Rectangle {
            implicitWidth: parent.width
            implicitHeight: parent.height
            radius: parent.radius
            opacity: parent.opacity
            color: tileColor
        }
        onClicked: {
            if (selectedBeer === 1 || selectedBeer < 0) {
                selectedBeer = 0
                displayCount = beer1Count
                displayABV = abv
                displayFat = 0
                displayCalories = 0
                displayCholesterol = 0
                displaySodium = 0
                displayCarbs = 0
                displayProtein = 0
                sizeSelected = 0
                //6a98c9
            }
        }
    }

    RectangularGlow {
        id: beer2Glow
        anchors.fill: beer2
        glowRadius: tileGlowRadius
        spread: 0.1
        color: "white"
        cornerRadius: beer2.radius + glowRadius
        visible: selectedBeer === 1 || selectedBeer === -1
    }

    RoundButton {
        id: beer2
        radius: 25
        width: 180
        height: 260
        anchors.verticalCenterOffset: -100
        anchors.horizontalCenterOffset: 125
        anchors.centerIn: parent
        // opacity: selectedBeer === 1 ? 1 : 0.5
        property int calories: 132
        property real abv: 5.2
        property real fat: 0
        property real cholesterol: 0
        property real sodium: 0
        property real carbs: 26
        property real protein: 2.5

        Image {
            id: beer2Image
            // anchors.fill:parent
            source: "Images/Tucher-helles.png"
            // sourceSize.width: parent.width
            // sourceSize.height: 100
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 30
            scale: 0.3
        }
        //make beer2Image glow
        Glow {
            anchors.fill: beer2Image
            source: beer2Image
            radius: 25
            spread: 0.2
            color: "white"
            scale: beer2Image.scale
        }

        Text {
            text: "Tucher Helles\n Hefe Weizen"
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 16
            color: "#FFFFFF"
        }

        background: Rectangle {
            implicitWidth: parent.width
            implicitHeight: parent.height
            radius: parent.radius
            opacity: parent.opacity
            color: tileColor
        }
        onClicked: {
            if (selectedBeer === 0 || selectedBeer < 0) {
                selectedBeer = 1
                displayCount = beer2Count
                displayABV = abv
                displayFat = 0
                displayCalories = 0
                displayCholesterol = 0
                displaySodium = 0
                displayCarbs = 0
                displayProtein = 0
                sizeSelected = 0
                //6a98c9
            }
        }
    }

    RectangularGlow {
        id: caloriesInfoGlow
        anchors.fill: caloriesInfo
        glowRadius: tileGlowRadius
        spread: 0.1
        color: glowColor
        cornerRadius: caloriesInfo.radius + glowRadius
    }

    Behavior on glowColor {
        ColorAnimation {
            duration: 2000
        }
    }

    Timer {
        id: colorTimer
        interval: 5000
        repeat: true
        running: true
        property int colorIndex: 0
        // Define a list of colors representing the RGB spectrum
        property var colorList: ["#ff0000", // Red
            "#ff7f00", // Orange
            "#ffff00", // Yellow
            "#00ff00", // Green
            "#00ffff", // Cyan
            "#0000ff", // Blue
            "#8a2be2", // Blue Violet
            "#4b0082", // Indigo
            "#9400d3", // Violet
            "#ff1493", // Deep Pink
            "#ff69b4", // Hot Pink
            "#ffc0cb", // Pink
            "#ff4500", // Orange Red
            "#ff8c00", // Dark Orange
            "#ffd700", // Gold
            "#adff2f", // Green Yellow
            "#32cd32", // Lime Green
            "#20b2aa", // Light Sea Green
            "#00fa9a", // Medium Spring Green
            "#00ced1" // Dark Turquoise
        ]
        onTriggered: {
            glowColor = colorList[colorIndex]
            colorIndex = (colorIndex + 1) % colorList.length
        }
    }

    Rectangle {
        id: caloriesInfo
        x: 40
        anchors.top: beer1.top
        width: 150
        height: 150
        color: tileColor
        radius: 25
        anchors.verticalCenterOffset: -25

        //border.color: glowcolor
        Text {
            id: caloriesNum
            text: displayCalories
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -20
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 48
            color: "#FFFFFF"
        }

        Text {
            text: "Calories"
            anchors.top: caloriesNum.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 16
            color: "#FFFFFF"
        }
    }

    RectangularGlow {
        id: abvInfoGlow
        anchors.fill: abvInfo
        glowRadius: tileGlowRadius
        spread: 0.1
        color: glowColor
        cornerRadius: abvInfo.radius + glowRadius
    }

    Rectangle {
        id: abvInfo
        //ABV %
        x: 822
        y: 240
        width: 150
        height: 150
        color: tileColor
        radius: 25
        Text {
            id: abvNum
            text: Math.round(displayABV * 100) / 100
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -20
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 48
            color: "#FFFFFF"
        }

        Text {
            text: "% ABV"
            anchors.top: abvNum.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 16
            color: "#FFFFFF"
        }
    }

    RectangularGlow {
        id: pouredInfoGlow
        anchors.fill: pouredInfo
        glowRadius: tileGlowRadius
        spread: 0.1
        color: glowColor
        cornerRadius: pouredInfo.radius + glowRadius
    }

    Rectangle {
        id: pouredInfo
        x: 822
        anchors.top: beer2.top
        width: 150
        height: 150
        color: tileColor
        //border.color: glowcolor
        radius: 25
        anchors.verticalCenterOffset: -25
        Text {
            id: pouredNum
            text: displayCount
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -20
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 48
            color: "#FFFFFF"
        }

        Text {
            text: "Total Ordered"
            anchors.top: pouredNum.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 16
            color: "#FFFFFF"
        }
    }

    RectangularGlow {
        id: shortOptionButtonGlow
        anchors.fill: shortOptionButton
        glowRadius: tileGlowRadius
        spread: 0.1
        color: "white"
        cornerRadius: shortOptionButton.radius + glowRadius
        visible: sizeSelected === 1 || sizeSelected === -1
    }

    RoundButton {
        id: shortOptionButton
        // x: 304
        y: 314
        anchors.verticalCenter: abvInfo.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: -75
        anchors.verticalCenterOffset: 30
        width: 180 / 2
        height: 65 / 2
        enabled: selectedBeer === 0 || selectedBeer === 1
        Text {
            text: "0,33L"
            anchors.centerIn: parent
            font.pointSize: 16
            color: "#FFFFFF"
        }

        background: Rectangle {
            implicitWidth: parent.width
            implicitHeight: parent.height
            radius: parent.radius
            opacity: parent.opacity
            color: tileColor
        }
        onClicked: {
            sizeSelected = 1
            if (selectedBeer === 0) {
                displayCalories = beer1.calories * (1 - .34)
                displayFat = beer1.fat * (1 - .34)
                displayCholesterol = beer1.cholesterol * (1 - .34)
                displaySodium = beer1.sodium * (1 - .34)
                displayCarbs = beer1.carbs * (1 - .34)
                displayProtein = beer1.protein * (1 - .34)
            } else if (selectedBeer === 1) {
                displayCalories = beer2.calories * (1 - .34)
                displayFat = beer2.fat * (1 - .34)
                displayCholesterol = beer2.cholesterol * (1 - .34)
                displaySodium = beer2.sodium * (1 - .34)
                displayCarbs = beer2.carbs * (1 - .34)
                displayProtein = beer2.protein * (1 - .34)
            }
        }
    }

    RectangularGlow {
        id: tallOptionButtonGlow
        anchors.fill: tallOptionButton
        glowRadius: tileGlowRadius
        spread: 0.1
        color: "white"
        cornerRadius: tallOptionButton.radius + glowRadius
        visible: sizeSelected === 2 || sizeSelected === -1
    }

    RoundButton {
        id: tallOptionButton
        // x: 516
        y: 314
        width: 180 / 2
        height: 65 / 2
        enabled: (selectedBeer >= 0)
        anchors.verticalCenter: abvInfo.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: 75
        anchors.verticalCenterOffset: 30
        radius: 25

        Text {
            text: "0,5L"
            font.pointSize: 16
            anchors.centerIn: parent
            color: "#FFFFFF"
        }

        background: Rectangle {
            implicitWidth: parent.width
            implicitHeight: parent.height
            radius: parent.radius
            opacity: parent.opacity
            color: tileColor
        }
        onClicked: {
            sizeSelected = 2
            if (selectedBeer === 0) {
                displayCalories = beer1.calories
                displayABV = beer1.abv
                displayFat = beer1.fat
                displayCholesterol = beer1.cholesterol
                displaySodium = beer1.sodium
                displayCarbs = beer1.carbs
                displayProtein = beer1.protein
            } else if (selectedBeer === 1) {
                displayCalories = beer2.calories
                displayABV = beer2.abv
                displayFat = beer2.fat
                displayCholesterol = beer2.cholesterol
                displaySodium = beer2.sodium
                displayCarbs = beer2.carbs
                displayProtein = beer2.protein
            }
        }
    }

    RectangularGlow {
        id: pourButtonGlow
        anchors.fill: pourButton
        glowRadius: tileGlowRadius
        spread: 0.1
        color: "white"
        cornerRadius: pourButton.radius + glowRadius
        visible: pourButton.enabled
    }

    RoundButton {
        id: pourButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: nutritionInfo.bottom
        width: 180
        height: 65
        // radius: 25
        enabled: sizeSelected > 0
        opacity: enabled ? 1 : 0.5

        Text {
            text: "Give me beer!"
            font.pointSize: 16
            anchors.centerIn: parent
            // color: "#FFFFFF"
        }

        onClicked: {
            if (selectedBeer) {
                beer2Count += 1
            } else {
                beer1Count += 1
            }

            selectedBeer = -1
            sizeSelected = 0
            displayCount = 0
            displayABV = 0
            displayCalories = 0
            displayCholesterol = 0
            displayProtein = 0
            displayFat = 0
            displaySodium = 0
            displayCarbs = 0

            MyTap.run_pump_for_seconds(0.5)
        }
    }

    Timer {
        property bool on: true
        running: selectedBeer < 0
        repeat: true
        interval: 750
        onTriggered: {
            if (on) {
                selectedBeer = -1
            } else {
                selectedBeer = -2
            }
            on = !on
        }
    }

    Timer {
        property bool on: true
        running: sizeSelected <= 0 && selectedBeer >= 0
        repeat: true
        interval: 750
        onTriggered: {
            if (on) {
                sizeSelected = -1
            } else {
                sizeSelected = 0
            }
            on = !on
        }
    }
}
