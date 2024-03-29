
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

Page {
    id: pane
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    width: Constants.width
    height: Constants.height - 75
    property color tileColor: "black" //Qt.lighter(AppSettings.accentColor,3.5)
    property color glowColor: "#55ff55" //add orange glow in light mode
    property real tileGlowRadius: 5
    property int beer1Count: 15
    property int beer2Count: 18
    property int selectedBeer: 0
    property int sizeSelected: -1
    property int selectedSize: 16
    property int displayCalories: beer1.calories
    property real displayABV: beer1.abv
    property int displayCount: beer1Count
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
        color: AppSettings.accentColor
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
        y: 265
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
            color: AppSettings.primaryTextColor
        }

        GridLayout {
            anchors.top: nutritionText.bottom
            anchors.bottom: parent.bottom
            columns: 2
            rows: 5
            columnSpacing: 35
            rowSpacing: 0

            Text {
                text: "Total Fat"
                color: AppSettings.primaryTextColor
                Layout.leftMargin: 15
            }
            Text {
                text: Math.round(displayFat * 100) / 100 + "g"
                color: AppSettings.primaryTextColor
            }

            Text {
                text: "Cholesterol"
                color: AppSettings.primaryTextColor
                Layout.leftMargin: 15
            }
            Text {
                text: Math.round(displayCholesterol * 100) / 100 + "g"
                color: AppSettings.primaryTextColor
            }

            Text {
                text: "Sodium"
                color: AppSettings.primaryTextColor
                Layout.leftMargin: 15
            }
            Text {
                text: Math.round(displaySodium * 100) / 100 + "g"
                color: AppSettings.primaryTextColor
            }

            Text {
                text: "Total Carbs"
                color: AppSettings.primaryTextColor
                Layout.leftMargin: 15
            }
            Text {
                text: Math.round(displayCarbs * 100) / 100 + "g"
                color: AppSettings.primaryTextColor
            }

            Text {
                text: "Protein"
                color: AppSettings.primaryTextColor
                Layout.leftMargin: 15
            }
            Text {
                text: Math.round(displayProtein * 100) / 100 + "g"
                color: AppSettings.primaryTextColor
            }
        }
    }

    RectangularGlow {
        id: beer1Glow
        anchors.fill: beer1
        glowRadius: tileGlowRadius
        spread: 0.1
        color: Qt.lighter(glowColor, 2)
        cornerRadius: beer1.radius + glowRadius
        visible: selectedBeer === 0
    }

    RoundButton {
        id: beer1
        y: 14
        radius: 25
        anchors.centerIn: parent
        width: 180
        height: 260
        anchors.verticalCenterOffset: -75
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
            color: AppSettings.primaryTextColor
        }

        background: Rectangle {
            implicitWidth: parent.width
            implicitHeight: parent.height
            radius: parent.radius
            opacity: parent.opacity
            color: tileColor
        }
        onClicked: {
            if (selectedBeer === 1) {
                selectedBeer = 0
                displayCalories = calories
                beer1Count += 1
                displayCount = beer1Count
                displayABV = abv
                displayFat = fat
                displayCholesterol = cholesterol
                displaySodium = sodium
                displayCarbs = carbs
                displayProtein = protein
                sizeSelected = -1
            }
        }
    }

    RectangularGlow {
        id: beer2Glow
        anchors.fill: beer2
        glowRadius: tileGlowRadius
        spread: 0.1
        color: Qt.lighter(glowColor, 2)
        cornerRadius: beer2.radius + glowRadius
        visible: selectedBeer === 1
    }

    RoundButton {
        id: beer2
        y: 14
        radius: 25
        width: 180
        height: 260
        anchors.verticalCenterOffset: -75
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
            color: AppSettings.primaryTextColor
        }

        background: Rectangle {
            implicitWidth: parent.width
            implicitHeight: parent.height
            radius: parent.radius
            opacity: parent.opacity
            color: tileColor
        }
        onClicked: {
            if (selectedBeer === 0) {
                selectedBeer = 1
                displayCalories = calories
                beer2Count += 1
                displayCount = beer2Count
                displayABV = abv
                displayFat = fat
                displayCholesterol = cholesterol
                displaySodium = sodium
                displayCarbs = carbs
                displayProtein = protein
                sizeSelected = -1
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

    Rectangle {
        id: caloriesInfo
        x: 40
        anchors.verticalCenter: beer1.verticalCenter
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
            color: AppSettings.primaryTextColor
        }

        Text {
            text: "Calories"
            anchors.top: caloriesNum.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 16
            color: AppSettings.primaryTextColor
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
        y: 265
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
            color: AppSettings.primaryTextColor
        }

        Text {
            text: "% ABV"
            anchors.top: abvNum.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 16
            color: AppSettings.primaryTextColor
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
        anchors.verticalCenter: beer2.verticalCenter
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
            color: AppSettings.primaryTextColor
        }

        Text {
            text: "Total Ordered"
            anchors.top: pouredNum.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 16
            color: AppSettings.primaryTextColor
        }
    }

    RectangularGlow {
        id: shortOptionButtonGlow
        anchors.fill: shortOptionButton
        glowRadius: tileGlowRadius
        spread: 0.1
        color: "white"
        cornerRadius: shortOptionButton.radius + glowRadius
        visible: sizeSelected === 0
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
        Text {
            text: "0,33L"
            anchors.centerIn: parent
            font.pointSize: 16
            color: AppSettings.primaryTextColor
        }

        background: Rectangle {
            implicitWidth: parent.width
            implicitHeight: parent.height
            radius: parent.radius
            opacity: parent.opacity
            color: tileColor
        }
        onClicked: {
            sizeSelected = 0
        }
    }

    RectangularGlow {
        id: tallOptionButtonGlow
        anchors.fill: tallOptionButton
        glowRadius: tileGlowRadius
        spread: 0.1
        color: "white"
        cornerRadius: tallOptionButton.radius + glowRadius
        visible: sizeSelected === 1
    }

    RoundButton {
        id: tallOptionButton
        // x: 516
        y: 314
        width: 180 / 2
        height: 65 / 2
        anchors.verticalCenter: abvInfo.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: 75
        anchors.verticalCenterOffset: 30
        radius: 25

        Text {
            text: "0,5L"
            font.pointSize: 16
            anchors.centerIn: parent
            color: AppSettings.primaryTextColor
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

    DelayButton {
        id: pourButton
        anchors.horizontalCenter: parent.horizontalCenter
        y: 430
        width: 180
        height: 65
        // radius: 25
        enabled: sizeSelected != -1
        opacity: enabled ? 1 : 0.5

        Text {
            text: "Give me beer!"
            font.pointSize: 16
            anchors.centerIn: parent
            // color: AppSettings.primaryTextColor
        }
        //make the button look pressed when pressed
    }
}
