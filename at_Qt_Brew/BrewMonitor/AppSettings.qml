pragma Singleton

import QtQuick
import QtCore

Settings {
    property bool isDarkTheme: Qt.styleHints.colorScheme === Qt.Dark
    property color backgroundColor: AppSettings.isDarkTheme ? "#000000" : "#EFFCF6"
    property color accentColor: AppSettings.isDarkTheme ? "#002125" : "#FFFFFF"
    property color primaryTextColor: AppSettings.isDarkTheme ? "#FFFFFF" : "#000000"
    property color accentTextColor: AppSettings.isDarkTheme ? "#D9D9D9" : "#898989"
    property color iconColor: AppSettings.isDarkTheme ? "#D9D9D9" : "#00414A"
}
