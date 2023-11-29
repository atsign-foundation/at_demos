
from at_client.connections.notification.atevents import AtEvent, AtEventType
from at_client.util.encryptionutil import EncryptionUtil
from at_client.common.keys import AtKey, Metadata, SharedKey
from at_client.common import AtSign
from at_client import AtClient
from time import sleep, time
import json

class Datapoint:
    def __init__(self, water_level: float, soil_moisture: float, temperature: float, humidity: float, timestamp: float):
        self.water_level = water_level
        self.soil_moisture = soil_moisture
        self.temperature = temperature
        self.humidity = humidity
        self.timestamp = timestamp
    def __str__(self) -> str:
        return json.dumps({'water_level': self.water_level, 'soil_moisture': self.soil_moisture, 'temperature': self.temperature, 'humidity': self.humidity, 'timestamp': self.timestamp})

def get_datapoints(atclient: AtClient, qt_app_atsign: AtSign, plant_atsign: AtSign, mm: int, dd: int, yyyy: int) -> list[Datapoint]:
    day_timestamps_sharedkey = SharedKey.from_string(str(qt_app_atsign) + ':' + str(mm) + '-' + str(dd) + '-' + str(yyyy) + '.days.qtplant' + str(plant_atsign)) # has form `@qt_app:MM-DD-YYYY.days.qtplant@qt_plant`
    try:
        day_timestamps_sharedkey_data = atclient.get(day_timestamps_sharedkey) # has form `[timestamp1, timestamp2, ...]`
    except:
        print("No timestamps found for %s-%s-%s" % (mm, dd, yyyy))
        return
    timestamps = day_timestamps_sharedkey_data[1:-1].split(', ')
    timestamps = [float(timestamp) for timestamp in timestamps] # has form `[timestamp1, timestamp2, ...]`
    datapoints = []
    for timestamp in timestamps:
        timestamp_sharedkey = SharedKey.from_string(str(qt_app_atsign) + ':' + str(timestamp) + '.datapoints.qtplant' + str(plant_atsign)) # has form `@qt_app:123.456.datapoints.qtplant@qt_plant`
        try:
            timestamp_sharedkey_data = atclient.get(timestamp_sharedkey) # has form `{"water_level": 0.0, "soil_moisture": 0.0, "temperature": 0.0, "humidity": 0.0"}`
        except:
            print("No data found for timestamp %s" % timestamp)
            continue
        # print("Timestamp data found (%s): %s" %(timestamp, timestamp_sharedkey_data))
        timestamp_sharedkey_data = json.loads(timestamp_sharedkey_data)
        water_level = timestamp_sharedkey_data['water_level']
        soil_moisture = timestamp_sharedkey_data['soil_moisture']
        temperature = timestamp_sharedkey_data['temperature']
        humidity = timestamp_sharedkey_data['humidity']
        datapoints.append(Datapoint(water_level, soil_moisture, temperature, humidity, timestamp))
    return datapoints

def run_pump_for_seconds(atclient: AtClient, qt_app_atsign: AtSign, plant_atsign: AtSign, seconds: int):
    timestamp = time()
    data = {
        'type': 'pumpWithSeconds',
        'timestamp': timestamp,
        'data': {
            'seconds': seconds
        }
    }
    data = json.dumps(data)
    sharedkey = SharedKey.from_string(str(plant_atsign) + ':pump.qtplant' + str(qt_app_atsign))
    iv_nonce = EncryptionUtil.generate_iv_nonce()
    metadata = Metadata(
        ttl=3600,
        ttr=-1,
        iv_nonce=iv_nonce,
    )
    sharedkey.metadata = metadata
    sleep(0.5)
    res = atclient.notify(sharedkey, data)
    print('Notification ID: %s' % res)
    print('SharedKey: %s' % sharedkey)
    print('Data: %s' % data)