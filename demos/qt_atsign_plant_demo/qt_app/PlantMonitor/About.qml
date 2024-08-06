import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Pdf

Pane {
    id: root
    background: Rectangle {
        color: Constants.accentColor
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
    }
}
