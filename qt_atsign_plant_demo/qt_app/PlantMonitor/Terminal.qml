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
        property alias buttonText: buttonText.text
        //width adjusts to content
        contentItem: Text {
            id: buttonText
            color: "#ffffff"
            text: "Run nmap command"
            font.pixelSize: 18
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.centerIn: parent
        }

        anchors.horizontalCenter: parent.horizontalCenter
        // anchors.top: view.bottom
        // anchors.centerIn: parent
        onClicked: {
            run.buttonText = "Running..."
            MyMonitor.runNmap()
        }

        background: Rectangle {
            color: "#FF5C35"
            radius: 5
        }
    }

    Text {
        id: text
        text: "Terminal Ouput Here"
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
                run.buttonText = "Run nmap command"
            }
        }
    }
}
