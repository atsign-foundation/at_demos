
from at_client.connections.notification.atevents import AtEvent, AtEventType
from at_client.util.encryptionutil import EncryptionUtil
from at_client.common.keys import AtKey, Metadata, SharedKey
from at_client.common import AtSign
from at_client import AtClient
import datetime
import queue
import json
from time import sleep

PLANT_ATSIGN_STR = '@qt_plant'
QT_APP_ATSIGN_STR = '@qt_app'
plant_atsign = AtSign(PLANT_ATSIGN_STR)
qt_app_atsign = AtSign(QT_APP_ATSIGN_STR)


def main():
    # Menu:
    #  1. Read timestamps of today (MM-DD-YYYY)
    #  2. Run pump for X seconds
    #  3. Exit

    atclient = AtClient(plant_atsign, queue=queue.Queue(
        maxsize=100), verbose=False)
    
    # print menu
    print("1. Read timestamps of today (MM-DD-YYYY)")
    print("2. Run pump for X seconds")
    print("3. Exit")
    

    choice = int(input("Enter choice: "))
    while choice in [1, 2, 3]:
        if (choice == 1):
            mm = datetime.datetime.now().month
            dd = datetime.datetime.now().day
            yyyy = datetime.datetime.now().year
            for i in range(100):
                day_timestamps_sharedkey = SharedKey.from_string(str(qt_app_atsign) + ':' + str(mm) + '-' + str(dd) + '-' + str(yyyy) + '.days.qtplant' + str(plant_atsign))
                try:
                    day_timestamps_sharedkey_data = atclient.get(day_timestamps_sharedkey) # form `[timestamp1, timestamp2, ...]`
                except:
                    print("No timestamps found for %s-%s-%s" % (mm, dd, yyyy))
                    break
                timestamps = day_timestamps_sharedkey_data[1:-1].split(', ')
                timestamps = [float(timestamp) for timestamp in timestamps]
                datapoints = []
                for timestamp in timestamps:
                    timestamp_sharedkey = SharedKey.from_string(str(qt_app_atsign) + ':' + str(timestamp) + '.datapoints.qtplant' + str(plant_atsign))
                    try:
                        timestamp_sharedkey_data = atclient.get(timestamp_sharedkey)
                    except:
                        print("No data found for timestamp %s" % timestamp)
                        continue
                    # print("Timestamp data found (%s): %s" %(timestamp, timestamp_sharedkey_data))
                    timestamp_sharedkey_data = json.loads(timestamp_sharedkey_data)
                    water_level = timestamp_sharedkey_data['water_level']
                    soil_moisture = timestamp_sharedkey_data['soil_moisture']
                    temperature = timestamp_sharedkey_data['temperature']
                    humidity = timestamp_sharedkey_data['humidity']
                    datapoints.append({'timestamp': timestamp, 'water_level': water_level, 'soil_moisture': soil_moisture, 'temperature': temperature, 'humidity': humidity})
                print('\nWater Level | Soil Moisture | Temperature | Humidity | Timestamp')
                print('------------|---------------|-------------|----------|----------')
                for datapoint in datapoints:
                    water_level = datapoint['water_level']
                    soil_moisture = datapoint['soil_moisture']
                    temperature = datapoint['temperature']
                    humidity = datapoint['humidity']
                    timestamp = datapoint['timestamp']
                    print('%.2f        | %.2f          | %.2f       | %.2f    | %s' % (water_level, soil_moisture, temperature, humidity, timestamp))
                print('\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n')
                sleep(1)
        elif (choice == 2):
            seconds = int(input("Enter seconds: "))

        elif (choice == 3):
            print("Exiting...")
            break
        print("1. Read timestamps of today (MM-DD-YYYY)")
        print("2. Run pump for X seconds")
        print("3. Exit")

        choice = int(input("Enter choice: "))


if __name__ == '__main__':
    main()
