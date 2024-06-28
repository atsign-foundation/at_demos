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
import RPi.GPIO as GPIO

DC_WATER_PUMP = 4 # GPIO PIN = 4
GPIO.setmode(GPIO.BCM)
GPIO.setup(DC_WATER_PUMP, GPIO.OUT)

beer_atsign = '@qt_beer'
app_atsign = '@qt_app_2'
namespace = 'qtbeer'

# Sends a notification to the app atsign that we have acknowledged the event. timestamp is not the current timestamp. timestamp is the timestamp of the notification that we are acknowledging (the timestamp came from the app and was generated by the app).
# @param atclient: authenticated AtClient object,
# @param timestamp: int, timestamp of the notification that we are acknowledging
# @return: notification id that was sent
def send_ack(atclient: AtClient, timestamp: int):
    data = {'timestamp': timestamp}
    payload = {
        'type': 'ack',
        'timestamp': int(time()),
        'data': data
        }

    data_to_send = json.dumps(payload)

    sharedkey = SharedKey.from_string(str(app_atsign) + ':ack.qtbeer' + str(beer_atsign))
    metadata = Metadata(
        ttl = 3*1000, # ttl = 3 second in miliseconds
        ttr = -1, # do not refresh, we don't care about any subsequent changes to this atkey
        iv_nonce = EncryptionUtil.generate_iv_nonce() , # required for encryption
    )
    sharedkey.metadata = metadata

    sleep(1)
    
    print('Sent %s %s' %(sharedkey, data_to_send))

    res = atclient.notify(sharedkey, data_to_send)
    return res

def run_pump(seconds: float):
    GPIO.output(DC_WATER_PUMP, GPIO.HIGH)
    sleep(seconds)
    GPIO.output(DC_WATER_PUMP, GPIO.LOW)

def main():
    print('Authenticating...')
    atclient = AtClient(AtSign(beer_atsign), queue=queue.Queue(maxsize=100), verbose=True)
    if atclient == None:
        print('Failed to authenticate.')
        return
    threading.Thread(target=atclient.start_monitor, args=(namespace,)).start()
    

    while True:
        at_event = atclient.queue.get()
        event_type = at_event.event_type
        event_data = at_event.event_data
        if event_type == AtEventType.UPDATE_NOTIFICATION:
                atclient.handle_event(atclient.queue, at_event)
                cmd = "notify:remove:" + str(event_data["id"])
                # print('Executing \'%s\'' %(cmd))
                atclient.secondary_connection.execute_command(cmd, retry_on_exception=3)
                pass
        if event_type != AtEventType.DECRYPTED_UPDATE_NOTIFICATION:
                continue

        # Now we are ready to process decrypted event data
        print('Event Data:')
        print(json.dumps(event_data, indent=4))

        decrypted_value = json.loads(event_data['decryptedValue'])

        timestamp = decrypted_value['timestamp']
        type = decrypted_value['type']
        data = decrypted_value['data']

        notification_id = send_ack(atclient, timestamp)
        print('Sent ack: %s' %(notification_id))

        if type == 'pumpWithSeconds':
            seconds = data['seconds']
            print('Pumping for %f seconds' % seconds)
            run_pump(float(seconds))
        sleep(1)

if __name__ == '__main__':
    main()