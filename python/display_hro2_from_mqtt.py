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

def on_message(mqttclient, userdata, message):
    beat_bpm_spo=(str(message.payload.decode("utf-8"))).split(",")
    print(beat_bpm_spo)
    beat=beat_bpm_spo[0]=='true'
    bpm=float(beat_bpm_spo[1])
    spo=float(beat_bpm_spo[2])
    display_hro2(beat,bpm,spo)


mqttclient=mqtt.Client("mwcpydisp")
mqttclient.connect("localhost")
mqttclient.loop_start()
mqttclient.subscribe("mqtt/mwc_beat_hr_o2")
mqttclient.on_message=on_message

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

def display_hro2(beat,avg_bpm,spo):
    lcd.fill((255, 255, 255))
    lcd.blit(defaultFont.render("Sensor Readings:", False, (0, 0, 0)),(10, 10))
    tidyHR = "HR: {:.0f}".format(avg_bpm)
    lcd.blit(defaultFont.render(tidyHR, False, (0, 0, 0)),(10, 30))
    if beat:
      lcd.blit(defaultFont.render("<3", False, (255, 0, 0)),(100, 30))
    tidySPO = "SO2: {0}%".format(spo)
    lcd.blit(defaultFont.render(tidySPO, False, (0, 0, 0)),(10, 50))
    refresh()

pygame.font.init()
defaultFont = pygame.font.SysFont(None,30)

input("HRO2 display running. Press enter to stop")
