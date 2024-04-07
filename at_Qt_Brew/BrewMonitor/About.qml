import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Pdf

Pane {
    id: root
    width: Constants.width
    height: Constants.height - 50
    background: Rectangle {
        id: back
        // color: "#002125"
    }

    PdfDocument {
        id: doc
        source: "Images/CES-slides.pdf"
    }

    PdfMultiPageView {
        id: view
        anchors.fill: parent
        document: doc
        //shrink pdf to fit in parent
        // next page when bottom half is tapped
        MouseArea {
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.top: parent.verticalCenter
            anchors.bottom: parent.bottom
            onClicked: {
                var cur = view.currentPage
                cur < 5 ? view.goToPage(cur + 1) : {}
                //set back.color to a randomized color
                back.color = Qt.rgba(Math.random(), Math.random(),
                                     Math.random(), 1)
            }
        }

        //prev page when top half is tapped
        MouseArea {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.verticalCenter
            onClicked: {
                var cur = view.currentPage
                cur ? view.goToPage(cur - 1) : {}
            }
        }

        Component.onCompleted: {
            view.scaleToWidth(parent.width, parent.height)
            //workaround for visual bug in pdf initial display position
            view.goToPage(0)
        }
    }

    Component.onCompleted: {
        //workaround for visual bug in pdf initial display position
        view.goToPage(3)
    }
}
