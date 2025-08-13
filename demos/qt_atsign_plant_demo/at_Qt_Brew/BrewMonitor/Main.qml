import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Pdf

Window {
    width: Constants.width
    height: Constants.height - 50
    visible: true
    title: qsTr("Beer!")

    // color: "#002125"
    StackView {
        id: stackView
        width: Constants.width
        height: Constants.height - 50
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
