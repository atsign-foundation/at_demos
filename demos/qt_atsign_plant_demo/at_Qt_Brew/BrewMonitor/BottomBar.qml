import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    width: Constants.width
    height: 50
    Rectangle {
        //background color
        color: "#002125"
        anchors.fill: parent
    }

    Image {
        id: atsignLogo
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: 10
        anchors.bottomMargin: 10
        sourceSize.height: 50
        source: "Images/atsign-logo-light.svg"
    }

    Button {
        id: homeButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: -85
        anchors.verticalCenter: parent.verticalCenter
        text: "Home"
        font.pointSize: 16
        width: 150
        onClicked: {
            if (!(stackView.currentItem instanceof Beer)) {
                stackView.replace("Beer.qml", StackView.PopTransition)
            }
        }
    }

    Button {
        text: "SSH No Ports"
        font.pointSize: 16
        anchors.left: homeButton.right
        anchors.verticalCenter: homeButton.verticalCenter
        anchors.leftMargin: 20
        width: 150
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
        source: "Images/Qt-logo-white.svg"
    }
}
