from PySide6.QtQml import QmlElement, QmlSingleton
from PySide6.QtCore import QObject, Slot, Property, Signal, Qt
from at_client.connections.notification.atevents import AtEvent, AtEventType
from at_client.util.encryptionutil import EncryptionUtil
from at_client.common import AtSign
from at_client.common.keys import AtKey, Metadata, SharedKey
from at_client import AtClient
from time import sleep, time
import threading
import queue
import datetime
import json
import random


QML_IMPORT_NAME = "io.qt.brew"
QML_IMPORT_MAJOR_VERSION = 1

#@QmlElement
@QmlSingleton
class BeerTap(QObject):

    def __init__(self):
        QObject.__init__(self)
        self.local = AtSign("@qt_app_2")
        self.local_atclient = AtClient(self.local, queue=queue.Queue(maxsize=100), verbose=False)

        self.remote = AtSign("@qt_beer")

    @Slot()
    def run_pump_for_seconds(self, seconds: int = 0.5):
        atclient = self.local_atclient
        qt_app_atsign = self.local
        beer_atsign = self.remote

        timestamp = int(time())
        data = {'seconds': seconds}
        payload = {
            'timestamp': timestamp,
            'type': 'pumpWithSeconds',
            'data': data
        }
        data = json.dumps(data)
        sharedkey = SharedKey.from_string(str(beer_atsign) + ':pump.qtbeer' + str(qt_app_atsign))
        iv_nonce = EncryptionUtil.generate_iv_nonce()
        metadata = Metadata(
            ttl=3000,
            ttr=-1,
            iv_nonce=iv_nonce,
        )
        sharedkey.metadata = metadata
        sleep(1)
        res = atclient.notify(sharedkey, data)

