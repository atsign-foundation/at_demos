from at_client.connections.notification.atevents import AtEvent, AtEventType
from at_client.util.encryptionutil import EncryptionUtil
from at_client.common.keys import AtKey, Metadata, SharedKey
from at_client.common import AtSign
from at_client import AtClient
import threading
import json
import queue
import RPi.GPIO as GPIO
from time import sleep, time
import Adafruit_ADS1x15
import dht11
import datetime

QT_APP_ATSIGN_STR = '@qt_app'
PLANT_ATSIGN_STR = '@qt_plant'
qt_app_atsign = AtSign(QT_APP_ATSIGN_STR)
plant_atsign = AtSign(PLANT_ATSIGN_STR)

def main():
    atclient = AtClient(plant_atsign, queue=queue.Queue(maxsize=100), verbose=False)
    atkeys: list[AtKey] = atclient.get_at_keys(regex='qtplant', fetch_metadata=False)
    count = 0
    for atkey in atkeys:
        res = atclient.delete(atkey)
        count += 1
    print('Deleted %s keys' % count)
    


if __name__ == '__main__':
    main()
    