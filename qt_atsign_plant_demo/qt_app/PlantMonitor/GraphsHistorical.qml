import QtQuick
import QtQuick.Layouts
import QtCharts
import QtQuick.Controls
import PlantMonitor

Item {
    id: root
    property int dateRange: 30

    GridLayout {
        anchors.fill: parent
        id: gridLayout
        columns: 2
        Layout.fillHeight: true
        Layout.fillWidth: true

        Repeater {
            id: repeater
            model: Object.keys(MyMonitor.model)
            delegate: Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: Constants.accentColor

                // ChartView with LineSeries
                ChartView {
                    id: chartView
                    anchors.fill: parent
                    antialiasing: true
                    legend.visible: true
                    backgroundColor: Constants.accentColor
                    plotAreaColor: Constants.accentColor
                    legend.labelColor: AppSettings.isDarkTheme ? "white" : "black"

                    DateTimeAxis {
                        id: xAxis
                        labelsColor: AppSettings.isDarkTheme ? "white" : "black"
                        format: "MM/dd"
                    }

                    // Y-axis definition
                    ValueAxis {
                        id: yAxis
                        min: 0
                        max: 50
                        labelsColor: AppSettings.isDarkTheme ? "white" : "black"
                    }

                    LineSeries {
                        id: lineSeries
                        axisX: xAxis
                        axisY: yAxis
                        name: modelData

                        Connections {
                            target: MyMonitor

                            function onModel_changed() {

                                // clear the lineSeries
                                lineSeries.clear()
                                var min = 100
                                var max = 0
                                for (var i = 0; i < dateRange; i++) {

                                    var y = MyMonitor.model[modelData][i][1]
                                    var minDate = new Date()
                                    var maxDate = new Date()

                                    maxDate.setDate(maxDate.getDate() - 1)

                                    minDate.setDate(minDate.getDate(
                                                        ) - dateRange)
                                    xAxis.min = minDate
                                    xAxis.max = maxDate

                                    var dateOfData = maxDate

                                    dateOfData.setDate(
                                                maxDate.getDate(
                                                    ) - (dateRange - (i + 1)))

                                    if (y < min) {
                                        min = y
                                        yAxis.min = (min * 0.95)
                                    }
                                    if (y > max) {
                                        max = y
                                        yAxis.max = (max * 1.05)
                                    }
                                    if (max === min) {
                                        yAxis.min = min - 5
                                        yAxis.max = max + 5
                                    }

                                    xAxis.tickCount = 7

                                    // console.log(dateOfData)
                                    lineSeries.append(dateOfData, y)
                                }
                            }
                        }
                    }
                }
            }
        }
        Component.onCompleted: {
            MyMonitor.get_past_30()
            pastMonthButton.enabled = false
        }
    }

    GridLayout {
        id: columnLayout
        //verically centered
        anchors.horizontalCenter: parent.horizontalCenter
        columns: 2
        rows: 2

        Button {
            id: pastWeekButton
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentItem: Text {
                text: "Past 7 Days"
                font.bold: !enabled
                color: AppSettings.isDarkTheme ? "white" : "black"
            }

            background: Rectangle {
                color: Constants.accentColor
                radius: 5
            }

            onClicked: {
                dateRange = 7
                MyMonitor.get_past_7()
                enabled = false
                pastMonthButton.enabled = true
            }
        }

        Button {
            id: pastMonthButton
            Layout.fillWidth: true
            Layout.fillHeight: true

            contentItem: Text {
                text: "Past 30 Days"
                font.bold: !enabled
                color: AppSettings.isDarkTheme ? "white" : "black"
            }

            background: Rectangle {
                color: Constants.accentColor
                radius: 5
                // border.color: AppSettings.isDarkTheme ? "white" : "black"
            }
            onClicked: {
                dateRange = 30
                MyMonitor.get_past_30()
                enabled = false
                pastWeekButton.enabled = true
            }
        }
        Rectangle {
            id: past7Indicator
            property bool selected: !pastWeekButton.enabled
            color: "#FF5C35"
            opacity: selected ? 1 : 0
            height: 3
            Layout.fillWidth: true
        }

        Rectangle {
            id: past30Indicator
            property bool selected: !pastMonthButton.enabled
            color: "#FF5C35"
            opacity: selected ? 1 : 0
            height: 3
            Layout.fillWidth: true
        }
    }
}
