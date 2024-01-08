import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Pdf
import PlantMonitor

Pane {
    id: root
    background: Rectangle {
        color: Constants.accentColor
    }

    PdfMultiPageView {
        id: view
        anchors.fill: parent

        //fill height with content
        document: PdfDocument {
            id: doc
            source: "Images/CES-slides.pdf"
        }
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

        Component.onCompleted: {
            view.scaleToPage(parent.width, parent.height)
            //make a QQmlPointFValueType
            var Point = Qt.point(1000, 0)
            view.goToLocation(0, Point, .5)
            // console.log(view.zoom)
        }
    }
}
