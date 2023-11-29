
from at_client.connections.notification.atevents import AtEvent, AtEventType
from at_client.util.encryptionutil import EncryptionUtil
from at_client.common.keys import AtKey, Metadata, SharedKey
from at_client.common import AtSign
from at_client import AtClient
import datetime
import queue
import json
from time import sleep
from helper import get_datapoints, run_pump_for_seconds

PLANT_ATSIGN_STR = '@qt_plant'
QT_APP_ATSIGN_STR = '@qt_app'
plant_atsign = AtSign(PLANT_ATSIGN_STR)
qt_app_atsign = AtSign(QT_APP_ATSIGN_STR)


def main():
    # Menu:
    #  1. Read timestamps of today (MM-DD-YYYY)
    #  2. Run pump for X seconds
    #  3. Exit

    atclient = AtClient(qt_app_atsign, queue=queue.Queue(
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
                datapoints = get_datapoints(atclient, qt_app_atsign, plant_atsign, mm, dd, yyyy)
                print('\nWater Level | Soil Moisture | Temperature | Humidity | Timestamp')
                print('------------|---------------|-------------|----------|----------')
                for datapoint in datapoints:
                    water_level = datapoint.water_level
                    soil_moisture = datapoint.soil_moisture
                    temperature = datapoint.temperature
                    humidity = datapoint.humidity
                    timestamp = datapoint.timestamp
                    print('%.2f        | %.2f          | %.2f       | %.2f    | %s' % (water_level, soil_moisture, temperature, humidity, timestamp))
                print('\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n')
                sleep(1)
        elif (choice == 2):
            seconds = int(input("Enter seconds: "))
            run_pump_for_seconds(atclient, qt_app_atsign, plant_atsign, seconds)
        elif (choice == 3):
            print("Exiting...")
            break
        print("1. Read timestamps of today (MM-DD-YYYY)")
        print("2. Run pump for X seconds")
        print("3. Exit")

        choice = int(input("Enter choice: "))


if __name__ == '__main__':
    main()
