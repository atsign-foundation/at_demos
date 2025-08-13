import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PlantMonitor

ScrollView {
    id: root

    clip: true

    //    contentWidth: availableWidth
    property alias columns: gridLayout.columns
    property alias gridWidth: gridLayout.width
    property alias gridHeight: gridLayout.height

    required property int delegatePreferredHeight
    required property int delegatePreferredWidth

    GridLayout {
        id: gridLayout

        columnSpacing: 5
        rowSpacing: 5

        Repeater {
            id: repeater
            model: Object.keys(MyMonitor.model)
            //            Component.onCompleted: {
            //                console.log("model type is " + typeof (model))
            //                if (Array.isArray(model)) {
            //                    console.log('It is an array')
            //                } else {
            //                    console.log('It is a generic object')
            //                }
            //            }
            delegate: DataTile {
                id: roomItem
                name: modelData
                Layout.preferredHeight: root.delegatePreferredHeight / 1.25
                Layout.preferredWidth: root.delegatePreferredWidth / 1.25
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}
