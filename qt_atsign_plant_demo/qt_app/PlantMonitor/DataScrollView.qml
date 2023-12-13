import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PlantMonitor

ScrollView {
    id: root

    clip: true
    contentWidth: availableWidth

    property alias columns: gridLayout.columns
    property alias gridWidth: gridLayout.width
    property alias gridHeight: gridLayout.height

    required property int delegatePreferredHeight
    required property int delegatePreferredWidth

    GridLayout {
        id: gridLayout

        columnSpacing: 24
        rowSpacing: 25

        Repeater {
            id: repeater
            model: Object.keys(MyMonitor.model)

            delegate: DataTile {
                id: roomItem
                name: modelData
                Layout.preferredHeight: root.delegatePreferredHeight
                Layout.preferredWidth: root.delegatePreferredWidth
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}
