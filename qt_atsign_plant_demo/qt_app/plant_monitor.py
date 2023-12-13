from PySide6.QtQml import QmlElement, QmlSingleton
from PySide6.QtCore import QObject, Slot, Property, Signal, QAbstractTableModel, QModelIndex, Qt
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


QML_IMPORT_NAME = "io.qt.plantinfo"
QML_IMPORT_MAJOR_VERSION = 1

class Datapoint:
    def __init__(self, water_level: float, soil_moisture: float, temperature: float, humidity: float, timestamp: float):
        self.water_level = water_level
        self.soil_moisture = soil_moisture
        self.temperature = temperature
        self.humidity = humidity
        self.timestamp = timestamp
    def __str__(self) -> str:
        return json.dumps({'water_level': self.water_level, 'soil_moisture': self.soil_moisture, 'temperature': self.temperature, 'humidity': self.humidity, 'timestamp': self.timestamp})

#@QmlElement
@QmlSingleton
class PlantMonitor(QObject):
    def __init__(self):
        QObject.__init__(self)


        sendDict = Signal("QVariantMap")

        self.local = AtSign("@39gorilla")
        self.local_atclient = AtClient(self.local, queue=queue.Queue(maxsize=100), verbose=False)

#        # the AtSign of the plant monitor
#        self.remote = AtSign("@standardcheetah")
        self.remote = AtSign("@qt_plant")

#        # a key shared with the remote device to request watering
#        self.shared_water_key = SharedKey("water", self.local, self.remote)

        # a key shared with us that contains plant information
        self.shared_plant_info_key = SharedKey("stats", self.remote, self.local)

        # self.model is a dict of plant information
        self._model = {
            "Soil Moisture": [0],
            "Temperature": [0],
            "Humidity": [0],
            "Water Level": [0],

        }
        self._dataSize = 0

    def get_datasize(self):
        return self._dataSize

    def set_datasize(self, new_size):
        self._dataSize = new_size
        self.datasize_changed.emit()

    def get_model(self):
        return self._model

    def set_model(self, new_model):
        print("updated model")
        self._model = new_model
        self.dataSize = len(self._model["Temperature"])
        print(f"new model is {new_model}")
        print(f"dataSize is {self.dataSize}")
        self.model_changed.emit()

    @Signal
    def model_changed(self):
        pass

    @Signal
    def datasize_changed(self):
        pass

    @Slot()
    # Example usage in your existing method
    def get_plant_info(self):
        mm = datetime.datetime.now().month
        dd = 1#datetime.datetime.now().day
        yyyy = datetime.datetime.now().year

        # Move the processing to a separate thread
        self.start_thread(self.local_atclient, self.local, self.remote, mm, dd, yyyy, self.set_model)


    def get_plant_info_in_thread(self, local_atclient, local, remote, mm, dd, yyyy, set_model):
        datapoints = self.get_datapoints(local_atclient, local, remote, mm, dd, yyyy)
        if len(datapoints) == 0:
            print(f"No data found for {mm}-{dd}-{yyyy}")
            return
        soil_moisture = []
        temperature = []
        humidity = []
        water_level = []
        for i, datapoint in enumerate(datapoints):
#            response = {
#                "Soil Moisture": round(datapoint.soil_moisture * (1 + (random.randint(-2, 2)/100)) * 100, 2),
#                "Temperature": datapoint.temperature,
#                "Humidity": datapoint.humidity * (1 + (random.randint(-2, 2)/100)),
#                "Light Level": random.randint(0, 10),
#                "Water Level": round((datapoint.water_level * (1 + (random.randint(-2, -1)/100))) * 100, 2), # don't do this. water level should only go down.
#                "Water Delivered": random.randint(0, 10)
#                # "Timestamp": datapoint.timestamp
#            }
#            response = json.dumps(response)
#            print(f"updated model with point {i} {response}")
#            #TODO: currently the plotting is not correct. we are getting 60 points at a time and only one is being plotted. we need to plot all of them.
#            set_model(json.loads(response))
            soil_moisture.append((i ,round(datapoint.soil_moisture * (1 + (random.randint(-2, 2)/100)) * 100, 2)))
            temperature.append((i, datapoint.temperature))
            humidity.append((i, datapoint.humidity * (1 + (random.randint(-2, 2)/100))))
            water_level.append((i, round((datapoint.water_level * (1 + (random.randint(-2, -1)/100))) * 100, 2)))
        response = {
            "Soil Moisture": soil_moisture,
            "Temperature": temperature,
            "Humidity": humidity,
            "Water Level": water_level,
        }
        response = json.dumps(response)
        print(f"updated model with {response}")
        set_model(json.loads(response))


    def start_thread(self,local_atclient, local, remote, mm, dd, yyyy, set_model):
        thread = threading.Thread(
            target=self.get_plant_info_in_thread,
            args=(local_atclient, local, remote, mm, dd, yyyy, set_model)
        )
        thread.start()



    @Slot(result=str)
    def deliver_water(self):
#        response = self.local_atclient.put(self.shared_water_key, "1")
        response = "{}"
#        print(response)
        return response

    model = Property(dict, get_model, set_model, notify=model_changed)
    dataSize = Property(int, get_datasize, set_datasize, notify=datasize_changed)

#def model_callback(engine):
#    monitor = PlantMonitor()
#    return monitor

    def get_datapoints(self, atclient: AtClient, qt_app_atsign: AtSign, plant_atsign: AtSign, mm: int, dd: int, yyyy: int) -> list[Datapoint]:
        datapoints = []
        day_timestamps_sharedkey = SharedKey.from_string(str(qt_app_atsign) + ':' + str(mm) + '-' + str(dd) + '-' + str(yyyy) + '.days.qtplant' + str(plant_atsign)) # has form `@qt_app:MM-DD-YYYY.days.qtplant@qt_plant`
        try:
            day_timestamps_sharedkey_data = atclient.get(day_timestamps_sharedkey) # has form `[timestamp1, timestamp2, ...]`
        except:
            # print("\tERR: No timestamps found for %s-%s-%s" % (mm, dd, yyyy))
            return datapoints
        timestamps = day_timestamps_sharedkey_data[1:-1].split(', ')
        timestamps = [float(timestamp) for timestamp in timestamps] # has form `[timestamp1, timestamp2, ...]`
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
#        [print(datapoint) for datapoint in datapoints]
        return datapoints

    def get_timestamp_atkeys(self, atclient: AtClient, qt_app_atsign: AtSign, plant_atsign: AtSign) -> list[AtKey]:
        atkeys: list[AtKey] = atclient.get_at_keys(regex='.datapoints.qtplant', fetch_metadata=False)
        return atkeys

    def run_pump_for_seconds(self, atclient: AtClient, qt_app_atsign: AtSign, plant_atsign: AtSign, seconds: int):
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
