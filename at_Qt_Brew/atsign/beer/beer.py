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

beer_atsign = '@qt_beer'
app_atsign = '@qt_app_2'
namespace = 'qtbeer'

def main():
    atclient = AtClient(AtSign(beer_atsign), queue=queue.Queue(maxsize=100), verbose=False)
    threading.Thread(target=atclient.start_monitor, args=(namespace,)).start()
    
    while True:
        at_event = atclient.queue.get(block=False)
        event_type = at_event.event_type
        event_data = at_event.event_data
        if event_type == AtEventType.UPDATE_NOTIFICATION:
                atclient.handle_event(atclient.queue, at_event)
                cmd = "notify:remove:" + str(event_data["id"])
                print('executing \'%s\'' %(cmd))
                atclient.secondary_connection.execute_command(cmd, retry_on_exception=3)
                pass
        if event_type != AtEventType.DECRYPTED_UPDATE_NOTIFICATION:
                continue
        print('Event Data: %s' %(str(event_data)))
        sleep(1)

if __name__ == '__main__':
    main()