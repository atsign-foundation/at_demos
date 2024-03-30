#!/usr/bin/env python3
from at_client.connections.notification.atevents import AtEvent, AtEventType
from at_client.util.encryptionutil import EncryptionUtil
from at_client.common.keys import AtKey, Metadata, SharedKey
from at_client.common import AtSign
from at_client import AtClient
import threading
import json
import queue
from time import sleep



# sends the notification

# @plant:pump.qtplant@qtapp
# {
#     “timestamp”: 3129319391
#     “type”: “pumpWithSeconds”
#     “data”: {
#         “seconds”: 3
#     }
# }

beer_atsign = '@qt_beer'
app_atsign = '@qt_app_2'

def run_pump_with_seconds(seconds: int):
    pass

def main():
    atclient = AtClient(AtSign(app_atsign), queue=queue.Queue(maxsize=100), verbose=False)
    threading.Thread(target=atclient.start_monitor, args=(namespace,)).start()


if __name__ == '__main__':
    main()