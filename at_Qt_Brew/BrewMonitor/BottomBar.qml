import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.platform

Item {
    width: 1024
    height: 75
    Rectangle {
        //background color
        color: AppSettings.accentColor
        anchors.fill: parent
    }

    Image {
        id: atsignLogo
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: 10
        anchors.bottomMargin: 10
        sourceSize.height: 50
        source: AppSettings.isDarkTheme ? "Images/atsign-logo-light.svg" : "Images/atsign-logo-dark.svg"
    }

    Button {
        text: "Beer Request"
        font.pointSize: 16
        anchors.right: homeButton.left
        anchors.verticalCenter: homeButton.verticalCenter
        anchors.rightMargin: 20
        width: 100
        onClicked: {

            //show color dialog
            colorDialog.open()
        }
    }
    ColorDialog {
        id: colorDialog
        onAccepted: {
            AppSettings.accentColor = colorDialog.color
            AppSettings.backgroundColor = colorDialog.color
        }
    }

    Button {
        id: homeButton
        anchors.centerIn: parent
        text: "Home"
        font.pointSize: 16
        width: 100
        onClicked: {
            if (!(stackView.currentItem instanceof Beer)) {
                stackView.replace("Beer.qml", StackView.PopTransition)
            }
        }
    }

    Button {
        text: "noports"
        font.pointSize: 16
        anchors.left: homeButton.right
        anchors.verticalCenter: homeButton.verticalCenter
        anchors.leftMargin: 20
        width: 100
        onClicked: {
            if (!(stackView.currentItem instanceof About)) {
                stackView.replace("About.qml", StackView.PushTransition)
            }
        }
    }

    Image {
        id: qtLogo
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 10
        anchors.bottomMargin: 10
        sourceSize.height: 50
        source: AppSettings.isDarkTheme ? "Images/Qt-logo-white.svg" : "Images/Qt-logo-black.svg"
    }
}
