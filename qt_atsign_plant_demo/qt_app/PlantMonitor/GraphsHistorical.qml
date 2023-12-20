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

                    //                     X-axis definition
                    //                                        ValueAxis {
                    //                                            id: xAxis
                    //                                            min: 0
                    //                                            max: 50
                    //                                            labelsColor: AppSettings.isDarkTheme ? "white" : "black"
                    //                                        }
                    DateTimeAxis {
                        id: xAxis
                        labelsColor: AppSettings.isDarkTheme ? "white" : "black"
                        format: "dd/MM"
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
                                //log MyMonitor.dataSize
                                //console.log("MyMonitor.dataSize: " + MyMonitor.dataSize)
                                //                            console.log("plotting historicals")
                                //time the function
                                //                            var start = new Date().getTime()

                                // clear the lineSeries
                                lineSeries.clear()
                                var min = 100
                                var max = 0
                                //                                xAxis.min = 1
                                //                                xAxis.max = MyMonitor.dataSize
                                for (var i = 0; i < dateRange; i++) {
                                    // update min and max compared with MyMonitor.model[modelData][i][1]
                                    //                                console.log("x is " + MyMonitor.model[modelData][i][0])
                                    //                                console.log("y is " + MyMonitor.model[modelData][i][1])
                                    var y = MyMonitor.model[modelData][i][1]

                                    //                                    var day = MyMonitor.model[modelData][i][0]
                                    var minDate = new Date()
                                    var maxDate = new Date()
                                    maxDate.setDate(maxDate.getDate() - 1)

                                    minDate.setDate(minDate.getDate(
                                                        ) - dateRange)
                                    xAxis.min = minDate
                                    xAxis.max = maxDate

                                    var dateOfData = new Date()

                                    // js is weird.
                                    if (dateRange == 7) {
                                        dateOfData.setDate(
                                                    minDate.getDate() + (i))
                                    } else {
                                        dateOfData.setDate(
                                                    minDate.getDate(
                                                        ) - (dateRange - i))
                                    }

                                    console.log(dateOfData)

                                    if (y < min) {
                                        min = y
                                        yAxis.min = min
                                    }
                                    if (y > max) {
                                        max = y
                                        yAxis.max = max
                                    }
                                    if (max === min) {
                                        yAxis.min = min - 5
                                        yAxis.max = max + 5
                                    }

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

    RowLayout {
        id: rowLayout
        //verically centered
        anchors.horizontalCenter: parent.horizontalCenter
        Button {
            id: pastWeekButton
            text: "Past 7 Days"
            Layout.fillWidth: true
            Layout.fillHeight: true
            onClicked: {
                dateRange = 7
                MyMonitor.get_past_7()
                enabled = false
                pastMonthButton.enabled = true
            }
            background: Rectangle {
                color: pastWeekButton.enabled ? Constants.accentColor : "green"
                radius: 5
                border.color: "black"
            }
        }
        Button {
            id: pastMonthButton
            text: "Last Month"
            Layout.fillWidth: true
            Layout.fillHeight: true
            onClicked: {
                dateRange = 30
                MyMonitor.get_past_30()
                enabled = false
                pastWeekButton.enabled = true
            }

            background: Rectangle {
                color: pastMonthButton.enabled ? Constants.accentColor : "green"
                radius: 5

                border.color: "black"
            }
        }
    }
}
