#!/usr/bin/env python3
from at_client.connections.notification.atevents import AtEvent, AtEventType
from at_client.util.encryptionutil import EncryptionUtil
from at_client.common.keys import AtKey, Metadata, SharedKey
from at_client.common import AtSign
from at_client import AtClient
import threading
import json
import queue
from time import sleep, time


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
namespace = 'qtbeer'

# Sends a notification to the beer atsign to run the pump for `seconds` seconds
# @param atclient: authenticated AtClient object,
# @param seconds: int, number of seconds to run the pump
# @return: notification id that was sent and the timestamp of the notification


def send_run_pump_with_seconds(atclient: AtClient, seconds: int):
    timestamp = int(time())
    data = {'seconds': seconds}
    payload = {
        'timestamp': timestamp,
        'type': 'pumpWithSeconds',
        'data': data
    }

    data_to_send = json.dumps(payload)

    sharedkey = SharedKey.from_string(
        str(beer_atsign) + ':pump.qtbeer' + str(app_atsign))
    metadata = Metadata(
        ttl=3*1000,  # ttl = 3 second in miliseconds
        ttr=-1,  # do not refresh, we don't care about any subsequent changes to this atkey
        iv_nonce=EncryptionUtil.generate_iv_nonce(),  # required for encryption
    )
    sharedkey.metadata = metadata

    sleep(1)

    res = atclient.notify(sharedkey, data_to_send)
    return (res, timestamp)


def main():
    atclient = AtClient(AtSign(app_atsign), queue=queue.Queue(
        maxsize=100), verbose=False)
    thread = threading.Thread(target=atclient.start_monitor, args=(namespace,))
    thread.start()

    (notification_id, timestamp) = send_run_pump_with_seconds(atclient, 3)
    print('Sent Notification ID: %s' % notification_id)

    # go through queue
    found_ack = False
    while not found_ack:
        at_event = atclient.queue.get()
        event_type = at_event.event_type
        if event_type == AtEventType.UPDATE_NOTIFICATION:
            # push it back onto the queue
            atclient.handle_event(atclient.queue, at_event)
            continue
        if event_type != AtEventType.DECRYPTED_UPDATE_NOTIFICATION:
            continue

        event_data = at_event.event_data
        print('Event Data: %s' % (str(event_data)))

        # Listen for acks
        decrypted_value = json.loads(event_data['decryptedValue'])
        data = decrypted_value['data']

        if decrypted_value['type'] == 'ack' and data['timestamp'] == timestamp:
            # Received acknowledgement
            print('Received Acknowledgement')
            found_ack = True
        cmd = "notify:remove:" + str(event_data["id"])
        print('Executing \'%s\'' % (cmd))
        atclient.secondary_connection.execute_command(cmd, retry_on_exception=3)

    thread.join()
    atclient.stop_monitor()


if __name__ == '__main__':
    main()
