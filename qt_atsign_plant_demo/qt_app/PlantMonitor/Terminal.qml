import QtQuick
import QtQuick.Controls
import PlantMonitor

Pane {
    id: root
    background: Rectangle {
        color: Constants.accentColor
    }
    // button that says "Run nmap"
    Button {
        id: run
        height: 50
        width: 100
        text: "Run nmap"
        anchors.horizontalCenter: parent.horizontalCenter
        // anchors.top: view.bottom
        // anchors.centerIn: parent
        onClicked: {
            run.text = "Running..."
            MyMonitor.runNmap()
        }

        background: Rectangle {
            color: "#FF5C35"
            radius: 5
        }
    }

    Text {
        id: text
        text: "Terminal Ouput here"
        font.pixelSize: 24
        width: parent.width
        //fill height as needed
        height: 250
        anchors.top: run.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        color: AppSettings.isDarkTheme ? "white" : "black"
        font.bold: true
        font.capitalization: Font.Capitalize
        //connection to MyMonitor outputChanged signal
        Connections {
            target: MyMonitor

            function onOutput_changed() {
                text.text = MyMonitor.terminalOutput
                run.text = "Run nmap"
            }
        }
    }
}
