import QtQuick
import QtQuick.Layouts
import QtCharts
import QtQuick.Controls
import PlantMonitor

GridLayout {
    id: root
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

                // X-axis definition
                //                ValueAxis {
                //                    id: xAxis
                //                    min: 0
                //                    max: 50
                //                    labelsColor: AppSettings.isDarkTheme ? "white" : "black"
                //                }
                DateTimeAxis {
                    id: xAxis
                    //                    min: Date.fromLocaleDateString(Qt.locale(),
                    //                                                   Locale.ShortFormat)
                    //                    max: {
                    //                        var maxDate = min
                    //                        maxDate.setMinutes(Qt.formatDateTime(maxDate,
                    //                                                             "mm") + 4.16)
                    //                                            maxDate.setSeconds(Qt.formatDateTime(maxDate,
                    //                                                                                 "s") + 9.6)
                    //                        return maxDate
                    //                    }
                    //format hh:mm:ss
                    format: "hh:mm:ss"

                    labelsColor: AppSettings.isDarkTheme ? "white" : "black"
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

                        // time this function
                        function onNotification_received() {

                            // get the data from the model
                            var date = new Date(MyMonitor.notificationModel[modelData][1] * 1000)
                            var dateObject = new Date(date)

                            if (lineSeries.count == 0) {
                                // initialize x axis values
                                var epochString = MyMonitor.notificationModel[modelData][1]
                                var epochValue = parseFloat(epochString)
                                epochValue += 60
                                var updatedEpochString = epochValue.toString()
                                var date2 = new Date(updatedEpochString * 1000)
                                var dateObject2 = new Date(date2)

                                xAxis.min = dateObject
                                xAxis.max = dateObject2
                                yAxis.min = yAxis.min
                                        = MyMonitor.notificationModel[modelData][0] / 0.75
                                yAxis.max = MyMonitor.notificationModel[modelData][0] * 1.1
                            } else if (lineSeries.count > 12) {
                                // 12 datapoints * 5 seconds per point = 1 minute of data
                                var newMin = new Date(lineSeries.at(1).x)
                                lineSeries.remove(0)
                                xAxis.min = newMin
                                xAxis.max = dateObject
                            }
                            // adjust y axis values
                            if (MyMonitor.notificationModel[modelData][0] <= yAxis.min) {
                                yAxis.min = MyMonitor.notificationModel[modelData][0] * 0.75
                            } else if (MyMonitor.notificationModel[modelData][0] >= yAxis.max) {
                                yAxis.max = MyMonitor.notificationModel[modelData][0] * 1.1
                            }

                            lineSeries.append(
                                        dateObject,
                                        MyMonitor.notificationModel[modelData][0])
                        }
                    }
                }
            }
        }
    }
    //    Connections {
    //        target: MyMonitor
    //        function onModel_changed() {
    //            Constants.timeStep++
    //        }
    //    }
}
