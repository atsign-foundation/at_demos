#!/usr/bin/env python3

##
# Prerequisites:
# A Touchscreen properly installed on your system:
# - a device to output to it, e.g. /dev/fb1
# - a device to get input from it, e.g. /dev/input/touchscreen
##

import time, evdev, select, math, os
os.environ["PYGAME_HIDE_SUPPORT_PROMPT"] = "hide"
import pygame

import paho.mqtt.client as mqtt
from max30105 import MAX30105, HeartRate

spo = 90

def on_message(mqttclient, userdata, message):
    global spo
    spo=str(message.payload.decode("utf-8"))

mqttclient=mqtt.Client("mwc")
mqttclient.connect("localhost")
mqttclient.loop_start()
mqttclient.subscribe("mqtt/mwc_o2")
mqttclient.on_message=on_message


max30105 = MAX30105()
max30105.setup(leds_enable=2)

max30105.set_led_pulse_amplitude(1, 0.2)
max30105.set_led_pulse_amplitude(2, 12.5)
max30105.set_led_pulse_amplitude(3, 0)

max30105.set_slot_mode(1, 'red')
max30105.set_slot_mode(2, 'ir')
max30105.set_slot_mode(3, 'off')
max30105.set_slot_mode(4, 'off')


# Very important: the exact pixel size of the TFT screen must be known so we can build graphics at this exact format
surfaceSize = (320, 240)
os.environ["XDG_RUNTIME_DIR"] = "/tmp/runtime-root"
# Note that we don't instantiate any display!
pygame.init()

# The pygame surface we are going to draw onto. 
# /!\ It must be the exact same size of the target display /!\
lcd = pygame.Surface(surfaceSize)

def refresh():
    # We open the TFT screen's framebuffer as a binary file.
    # Note that we will write bytes into it, hence the "wb" operator
    f = open("/dev/fb1","wb")
    # According to the TFT screen specs, it supports only 16bits pixels depth
    # Pygame surfaces use 24bits pixels depth by default,
    # but the surface itself provides a very handy method to convert it.
    # once converted, we write the full byte buffer of the pygame surface 
    # into the TFT screen framebuffer like we would in a plain file:
    f.write(lcd.convert(16,0).get_buffer())
    # We can then close our access to the framebuffer
    f.close()

# Now we've got a function that can get the bytes from a pygame surface to the TFT framebuffer, 
# we can use the usual pygame primitives to draw on our surface before calling the refresh function.

def display_heartrate(beat, bpm, avg_bpm):
    #print("{} BPM: {:.2f}  AVG: {:.2f}".format("<3" if beat else "  ",
    #      bpm, avg_bpm))
    lcd.fill((255, 255, 255))
    lcd.blit(defaultFont.render("Sensor Readings:", False, (0, 0, 0)),(10, 10))
    tidyHR = "HR: {:.0f}".format(avg_bpm)
    lcd.blit(defaultFont.render(tidyHR, False, (0, 0, 0)),(10, 30))
    if beat:
      lcd.blit(defaultFont.render("<3", False, (255, 0, 0)),(100, 30))
    tidySPO = "SO2: {0}%".format(spo)
    lcd.blit(defaultFont.render(tidySPO, False, (0, 0, 0)),(10, 50))
    refresh()
    mqttclient.publish("mqtt/mwc_hr",avg_bpm)

pygame.font.init()
defaultFont = pygame.font.SysFont(None,30)

hr = HeartRate(max30105)

try:
    hr.on_beat(display_heartrate, average_over=4)
except KeyboardInterrupt:
    pass
