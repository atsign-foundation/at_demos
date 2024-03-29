# This Python file uses the following encoding: utf-8
import sys
from pathlib import Path

# from PySide6.QtGui import QGuiApplication
from PySide6.QtWidgets import QApplication
from PySide6.QtQml import QQmlApplicationEngine, qmlRegisterSingletonType


if __name__ == "__main__":
    app = QApplication(sys.argv)
    QApplication.setApplicationName("BrewMonitorApp");
    QApplication.setOrganizationName("QtProject");

    engine = QQmlApplicationEngine()

    engine.addImportPath(Path(__file__).parent)
    engine.loadFromModule("BrewMonitor", "Main")
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
