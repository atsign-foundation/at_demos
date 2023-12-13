import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import PlantMonitor

Window {
    id: window
    width: Constants.width
    height: Constants.height
    minimumHeight: 272
    minimumWidth: Qt.PrimaryOrientation === Qt.LandscapeOrientation ? 480 : 360
    visible: true
    title: qsTr("Plant Health Monitor")

    Home {
        id: mainScreen
        anchors.fill: parent
    }

    Timer {
        interval: Constants.tickRate
        repeat: true
        running: true
        onTriggered: {
            MyMonitor.get_plant_info()
            // Constants.timeStep++
        }
    }

    Component.onCompleted: function () {
        Constants.isBigDesktopLayout = Qt.binding(function () {
            return window.width >= Constants.width
                    && window.width >= window.height
        })
        Constants.isSmallDesktopLayout = Qt.binding(function () {
            return window.width >= 647 && window.width < Constants.width
                    && window.width >= window.height
        })
        Constants.isMobileLayout = Qt.binding(function () {
            return window.width < window.height
        })
        Constants.isSmallLayout = Qt.binding(function () {
            return window.width < 647 && window.width >= window.height
        })
    }
}
