#!/usr/bin/env python3
from at_client.connections.notification.atevents import AtEvent, AtEventType
from at_client.util.encryptionutil import EncryptionUtil
from at_client.common.keys import AtKey, Metadata, SharedKey
from at_client.common import AtSign
from at_client import AtClient
import queue
from time import sleep, time

QT_APP_ATSIGN_STR = '@qt_app'
PLANT_ATSIGN_STR = '@qt_plant'
qt_app_atsign = AtSign(QT_APP_ATSIGN_STR)
plant_atsign = AtSign(PLANT_ATSIGN_STR)

def main():
    atclient = AtClient(plant_atsign, queue=queue.Queue(maxsize=100), verbose=False)
    atkeys: list[AtKey] = atclient.get_at_keys(regex='qtplant', fetch_metadata=False)
    i = 0
    for atkey in atkeys:
        atclient.delete(atkey)
        i += 1
    print('deleted {} keys'.format(i))

if __name__ == '__main__':
    main()
