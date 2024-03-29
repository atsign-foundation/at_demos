import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Pdf

Window {
    width: Constants.width
    height: Constants.height
    visible: true
    title: qsTr("Beer!")

    // color: AppSettings.accentColor
    StackView {
        id: stackView
        width: Constants.width
        height: Constants.height - 75
        initialItem: Beer {
            id: beer
            anchors.fill: parent
        }

        About {
            id: about
            anchors.fill: parent
        }
    }

    BottomBar {
        anchors.bottom: parent.bottom
        width: parent.width
    }
}
