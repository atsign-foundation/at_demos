# This Python file uses the following encoding: utf-8
import sys
import plant_monitor
from pathlib import Path

from PySide6.QtWidgets import QApplication
from PySide6.QtQml import QQmlApplicationEngine, qmlRegisterSingletonType

if __name__ == "__main__":
    app = QApplication(sys.argv)
    QApplication.setApplicationName("PlantMonitorApp");
    QApplication.setOrganizationName("QtProject");
    engine = QQmlApplicationEngine()
    #register the PlantMonitor singleton
    qmlRegisterSingletonType(plant_monitor.PlantMonitor, "PlantMonitor", 1, 0, "MyMonitor")
    engine.addImportPath(Path(__file__).parent)
    engine.loadFromModule("PlantMonitor", "Main")
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
