#!/usr/bin/env python3
from at_client.connections.notification.atevents import AtEvent, AtEventType
from at_client.util.encryptionutil import EncryptionUtil
from at_client.common.keys import AtKey, Metadata, SharedKey
from at_client.common import AtSign
from at_client import AtClient
import datetime
import queue
import json
from time import sleep
from helper import get_datapoints, run_pump_for_seconds, get_timestamp_atkeys

PLANT_ATSIGN_STR = '@qt_plant'
QT_APP_ATSIGN_STR = '@qt_app'
plant_atsign = AtSign(PLANT_ATSIGN_STR)
qt_app_atsign = AtSign(QT_APP_ATSIGN_STR)


def print_menu():
    print("\n1. Read timestamps of today (MM-DD-YYYY)")
    print("2. Read most recent timestamp")
    print("3. Run pump for X seconds")
    print("4. Delete a timestamp")
    print("5. Exit\n")

def handle_choice_1(atclient: AtClient):
    mm = datetime.datetime.now().month
    dd = datetime.datetime.now().day
    yyyy = datetime.datetime.now().year
    datapoints = get_datapoints(atclient, qt_app_atsign, plant_atsign, mm, dd, yyyy)
    if len(datapoints) == 0:
        print("No data found for %s-%s-%s" % (mm, dd, yyyy))
        return
    print('\nWater Level | Soil Moisture | Temperature | Humidity | Timestamp')
    print('------------|---------------|-------------|----------|----------')
    for datapoint in datapoints:
        water_level = datapoint.water_level
        soil_moisture = datapoint.soil_moisture
        temperature = datapoint.temperature
        humidity = datapoint.humidity
        timestamp = datapoint.timestamp
        print('%.2f        | %.2f          | %.2f       | %.2f    | %s' %
                (water_level, soil_moisture, temperature, humidity, timestamp))
    print('\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n')

def handle_choice_2(atclient: AtClient):
    mm = datetime.datetime.now().month
    dd = datetime.datetime.now().day
    yyyy = datetime.datetime.now().year
    datapoints = get_datapoints(atclient, qt_app_atsign, plant_atsign, mm, dd, yyyy)
    datapoints.sort(key=lambda datapoint: datapoint.timestamp, reverse=True)
    if len(datapoints) == 0:
        print("No data found")
        return
    datapoint = datapoints[0]
    water_level = datapoint.water_level
    soil_moisture = datapoint.soil_moisture
    temperature = datapoint.temperature
    humidity = datapoint.humidity
    timestamp = datapoint.timestamp
    
    # from tiemstamp, get mm, dd, yyyy, hh, mm, ss
    timestamp_datetime = datetime.datetime.fromtimestamp(timestamp)
    mm = timestamp_datetime.month
    dd = timestamp_datetime.day
    yyyy = timestamp_datetime.year
    hh = timestamp_datetime.hour
    minute = timestamp_datetime.minute
    ss = timestamp_datetime.second
    
    print('Date: %s/%s/%s %s:%s:%s' %(str(mm), str(dd), str(yyyy), str(hh), str(minute), str(ss)))
    print('\nWater Level | Soil Moisture | Temperature | Humidity | Timestamp')
    print('------------|---------------|-------------|----------|----------')
    print('%.2f        | %.2f          | %.2f       | %.2f    | %s' %(water_level, soil_moisture, temperature, humidity, timestamp))

def handle_choice_3(atclient: AtClient):
    seconds = int(input("Enter seconds: "))
    run_pump_for_seconds(atclient, qt_app_atsign, plant_atsign, seconds)
    
def handle_choice_4(atclient: AtClient):
    atkeys = get_timestamp_atkeys(atclient, qt_app_atsign, plant_atsign)
    print(atkeys)

def main():
    atclient = AtClient(qt_app_atsign, queue=queue.Queue(
        maxsize=100), verbose=False)

    print_menu()
    choice = int(input("Enter choice: "))
    while choice in [1, 2, 3, 4, 5]:
        if (choice == 1):
            handle_choice_1(atclient)
        elif (choice == 2):
            handle_choice_2(atclient)
        elif (choice == 3):
            handle_choice_3(atclient)
        elif (choice == 4):
            handle_choice_4(atclient)
        elif (choice == 5):
            print("Exiting...")
            break
        print_menu()
        choice = int(input("Enter choice: "))


if __name__ == '__main__':
    main()
