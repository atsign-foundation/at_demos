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

        self.local = AtSign("@qt_app")
        self.local_atclient = AtClient(self.local, queue=queue.Queue(maxsize=100), verbose=False)

        # the AtSign of the plant monitor

        self.remote = AtSign("@qt_plant")

        # a key shared with us that contains plant information
        self.shared_plant_info_key = SharedKey("stats", self.remote, self.local)
        self.soil_moisture_avgs = []
        self.temperature_avgs = []
        self.humidity_avgs = []
        self.water_level_avgs = []

        self.stored_dict = {}

        self._notificationModel = {
            "Soil Moisture": [0],
            "Temperature": [0],
            "Humidity": [0],
            "Water Level": [0],
        }

        # self.model is a dict of plant historical information
        self._model = {
            "Soil Moisture": [0],
            "Temperature": [0],
            "Humidity": [0],
            "Water Level": [0],

        }
        self._dataSize = 0

        # Start the thread when the class is instantiated
        self.start_listen_thread()

    def get_notification_model(self):
        return self._notificationModel

    def set_notification_model(self, new_model):
        self._notificationModel = new_model
#        print(f"new notification model is {new_model}")
        self.notification_received.emit()

    def get_datasize(self):
        return self._dataSize

    def set_datasize(self, new_size):
        self._dataSize = new_size
        self.datasize_changed.emit()

    def get_model(self):
        return self._model

    def set_model(self, new_model):
#        print("updated model")
        self._model = new_model
#        print(f"new model is {new_model}")
        self.dataSize = len(self._model["Temperature"])
#        print(f"new model is {new_model}")
#        print(f"dataSize is {self.dataSize}")
        self.model_changed.emit()

    @Signal
    def model_changed(self):
        pass

    @Signal
    def notification_received(self):
        pass

    @Signal
    def datasize_changed(self):
        pass

    def start_listen_thread(self):
        # Create a thread to run listen_for_data
        self.listen_thread = threading.Thread(target=self.listen_for_data)
        self.listen_thread.daemon = True  # Set the thread as a daemon so that it exits when the main thread exits
        self.listen_thread.start()

    def stop_listen_thread(self):
        self.listen_thread.join()


    @Slot()
    def get_past_30(self):
        #set self._model dict to the dictionary stored in December.json
        with open('Past30.json', 'r') as f:
            self.set_model(json.load(f))

    @Slot()
    def get_past_7(self):
        #set self._model dict to the dictionary stored in December.json
        with open('Past7.json', 'r') as f:
            self.set_model(json.load(f))

    @Slot()
    # Example usage in your existing method
    def get_plant_info(self):
        global DAY
        mm = datetime.datetime.now().month
        dd = datetime.datetime.now().day
        yyyy = datetime.datetime.now().year
        print(f"getting plant info for {mm}-{dd}-{yyyy}")
        # print type and value of mm
        print(f"mm is {type(mm)} and value is {mm}")
        # print type and value of dd
        print(f"dd is {type(dd)} and value is {dd}")
        # print type and value of yyyy
        print(f"yyyy is {type(yyyy)} and value is {yyyy}")

        # Move the processing to a separate thread
        self.start_thread(self.local_atclient, self.local, self.remote, mm, dd, yyyy, self.set_model)



    def get_plant_info_in_thread(self, local_atclient, local, remote, mm, dd, yyyy, set_model):
        # time this function
#        start = time()

        datapoints = self.get_datapoints(local_atclient, local, remote, mm, dd, yyyy)
        if len(datapoints) == 0:
            print(f"No data found for {mm}-{dd}-{yyyy}")
            return
        soil_moisture = []
        temperature = []
        humidity = []
        water_level = []
        for i, datapoint in enumerate(datapoints):
            soil_moisture.append((i ,round(datapoint.soil_moisture * (1 + (random.randint(-2, 2)/100)), 2)))
            temperature.append((i, datapoint.temperature))
            humidity.append((i, datapoint.humidity * (1 + (random.randint(-2, 2)/100))))
            water_level.append((i, round((datapoint.water_level * (1 + (random.randint(-2, -1)/100))), 2)))
        response = {
            "Soil Moisture": soil_moisture,
            "Temperature": temperature,
            "Humidity": humidity,
            "Water Level": water_level,
        }
        response = json.dumps(response)

        # average of soil_moisture list of lists at index 1
        self.soil_moisture_avgs.append([dd, sum([i[1] for i in soil_moisture]) / len(soil_moisture)])
        self.temperature_avgs.append([dd, sum([i[1] for i in temperature]) / len(temperature)])
        self.humidity_avgs.append([dd, sum([i[1] for i in humidity]) / len(humidity)])
        self.water_level_avgs.append([dd, sum([i[1] for i in water_level]) / len(water_level)])
        self.stored_dict = {
            "Soil Moisture": self.soil_moisture_avgs,
            "Temperature": self.temperature_avgs,
            "Humidity": self.humidity_avgs,
            "Water Level": self.water_level_avgs,
        }
        print(f"stored dict is {self.stored_dict}")

#        print(f"updated model with {response}")
        set_model(json.loads(response))
#        end = time()
#        print(f"get_plant_info_in_thread took {end - start} seconds")


    def start_thread(self,local_atclient, local, remote, mm, dd, yyyy, set_model):
        thread = threading.Thread(
            target=self.get_plant_info_in_thread,
            args=(local_atclient, local, remote, mm, dd, yyyy, set_model)
        )
        thread.start()


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
#            print("Timestamp data found (%s): %s" %(timestamp, timestamp_sharedkey_data))
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

    @Slot()
    def run_pump_for_seconds(self, seconds: int = 5):
        atclient = self.local_atclient
        qt_app_atsign = self.local
        plant_atsign = self.remote

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


    def listen_for_data(self):
        atclient = AtClient(self.local, queue=queue.Queue(maxsize=100), verbose=False)

        #delete any cached and then start listening
#        atkeys: list[AtKey] = atclient.get_at_keys(regex='sensors.qtplant', fetch_metadata=False)
#        print(atkeys)
#        i = 0
#        for atkey in atkeys:
#            atclient.delete(atkey)
#            i += 1
#        print('deleted {} keys'.format(i))

        threading.Thread(target=atclient.start_monitor, args=("sensors.qtplant",)).start()

        while True:
            try:
                at_event = atclient.queue.get(block=False)
                # print("Event: %s" % at_event)
                event_type = at_event.event_type
                event_data = at_event.event_data
                # print("Event type: %s" % event_type)

                if event_type == AtEventType.UPDATE_NOTIFICATION:
#                        print("tying to handle update notification event")
                        atclient.handle_event(atclient.queue, at_event)
                        cmd = "notify:remove:" + str(event_data["id"])
#                        print('executing \'%s\'' %(cmd))
                        atclient.secondary_connection.execute_command(cmd, retry_on_exception=3)
#                        print('executed \'%s\'' %(cmd))
                if event_type != AtEventType.DECRYPTED_UPDATE_NOTIFICATION:
                        continue
                # print("Event data: %s" % event_data)
                try:
                    decrypted_value_dict = json.loads(event_data['decryptedValue'])
                except:
                    print('(1) Failed to parse `%s`' % event_data['decryptedValue'])
                    continue

                try:
                    q_type: str = decrypted_value_dict['type']
                    q_timestamp: float = decrypted_value_dict['timestamp']
                    q_data: dict = decrypted_value_dict['data']
#                    print("\nType (%s): %s" %(type(q_type), q_type))
#                    print("Timestamp (%s): %s" %(type(q_timestamp), q_timestamp))
#                    print("Data (%s): %s" %(type(q_data), q_data))
                    if q_type == 'sensorData':
                        # Capitalize the keys (GUI will display the keys as they come)
                        # print(f"received data: {q_data}")
                        # print("premature emit")
                        q_data["Temperature"] = q_data.pop("temperature")
                        q_data["Humidity"] = q_data.pop("humidity")
                        q_data["Soil Moisture"] = q_data.pop("soil_moisture")
                        q_data["Water Level"] = q_data.pop("water_level")
                        q_data["Timestamp"] = q_data.pop("timestamp")

                        timestamp = q_data.pop("Timestamp", None)
#                        print(q_data)
                        if timestamp is not None:
                            for key, value in q_data.items():
                                q_data[key] = [value, timestamp]


                        print(f"changed q_data to {q_data}")
                        print("setting model from notification")
                        self.set_notification_model(q_data)

                except Exception as e:
                    # print(e)
                    pass
            except Exception as e:
#                print(e)
                pass

            sleep(1)




    model = Property(dict, get_model, set_model, notify=model_changed)
    notificationModel = Property(dict, get_notification_model, set_notification_model, notify=notification_received)
    dataSize = Property(int, get_datasize, set_datasize, notify=datasize_changed)
