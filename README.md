<img width=250px src="https://atsign.dev/assets/img/atPlatform_logo_gray.svg?sanitize=true">

# Mobile World Congress Demo

This repo holds the files for Atsign and Zariot demo for MWC 2022 and IoTExpo 2022.

For background take a look at the [press release](https://www.zariot.com/blog/zariot-kigen-and-the-company-stem-chaos-in-iot-through-true-e2e-encryption-and-sim-technology/)
and the white paper [Flipping The Internet of Things (IoT)](https://www.zariot.com/resources/flipping-the-internet-of-things/).

There's a short video overview followed by some Q&A in this episode of
[Flutter Humpday](https://www.youtube.com/watch?v=zh7sM3RuOZk&t=488s).

[The Data Ownership model](https://viewer.diagrams.net/?tags=%7B%7D&highlight=0000ff&edit=_blank&layers=1&nav=1#G1il8chiwEajA-xlA3A4yQ6hFFAtn3zEWD)

## at_cli

A simple script to use the at_cli tool to read from MQTT and send updates to
an Atsign.

This is no longer used in the demo, but left in place as an example.

## dart/iot_sender - iot_sender

A dart app to read from MQTT and send to an Atsign.

First put the sending atSign .atKeys file in ~/.atsign/keys. If you do not have the .atKeys file then register an atSign in an Atsign app and save your keys this will give you the needed key file.

```bash
cd dart/iot_sender
dart pub get
dart run ./bin/iot_sender.dart -a "@sendingatsign" -o "@receivingatsign"
```

When the sender is going to be used repeatedly it should be compiled:

```bash
cd dart/iot_sender
dart pub get
dart compile exe ./bin/iot_sender.dart -o sender
```

The systemd units expect to find a compiled `sender` binary.

## dart/iot_sender - iot_sensor_publisher

A dart app to read from the MAX30101 sensor and place values onto
MQTT topics.

```bash
cd dart/iot_sender
dart pub get
dart run ./bin/iot_sensor_publisher.dart
```

When the publisher is going to be used repeatedly it should be compiled:

```bash
cd dart/iot_sender
dart pub get
dart compile exe ./bin/iot_sensor_publisher.dart -o spub
```

The systemd units expect to find a compiled `spub` binary.

## flutter/iot_receiver

A flutter app to receive data from dart/iot_sender and display it on dials.

To run the Windows version:

```
cd flutter/iot_receiver
flutter pub get
flutter run -d windows
```

## gsm

Details of using a SIM card to store keys, and config files for ppp connection
with the cellular modem.

Of course you'll need a SIM, which can be ordered from ZARIOT's
[test now](https://www.zariot.com/test-now/) page.

## python

### display_hro2_from_mqtt.py

Reads data from MQTT (sent by spub) and displays it on the local LCD display
using pygame.

### hrmqttsolcd.py

Reads data from MAX30101 sensor then puts it onto MQTT queue whilst also
printing out values to local LCD display using pygame.

This is no longer used, but has been left as an example.

## shell

O2sender.sh was used during testing to place O2 values onto an MQTT topic.

## systemd

Unit definitions to start the demo as a set of services running in detached
GNU screens.

## Raspberry Pi setup

### Bill of Materials

* [Raspberry Pi 4 Model B](https://thepihut.com/products/raspberry-pi-4-model-b?variant=20064052740158) (2GB or 4GB)
* [Raspberry Pi 4 Power Supply](https://thepihut.com/products/raspberry-pi-psu-uk?variant=20064070303806)
* [Heatsink Case for Raspberry Pi 4](https://thepihut.com/products/aluminium-armour-heatsink-case-for-raspberry-pi-4?variant=31139034038334)
* [SIM7600X 4G HAT](https://thepihut.com/products/4g-hat-for-raspberry-pi-lte-cat-4-3g-2g-with-gnss-positioning?variant=39761668374723)
* [SSD to USB 3.0 Cable](https://thepihut.com/products/ssd-to-usb-3-0-cable-for-raspberry-pi?variant=38191015559363)
* [120GB 2.5" SSD](https://thepihut.com/products/wd-green-120gb-2-5-ssd?variant=37628144648387)
* [Adafruit PiTFT 2.4" HAT Mini Kit](https://thepihut.com/products/adafruit-pitft-2-4-hat-mini-kit-320x240-tft-touchscreen?variant=13930056004)
* [MAX30105 Breakout](https://thepihut.com/products/max30105-breakout-heart-rate-oximeter-smoke-sensor?variant=32180290355262) NB MAX30101 supplied
* [Extra-Tall Push-Fit Stacking GPIO Header for Raspberry Pi](https://thepihut.com/products/40-pin-extra-tall-header-push-fit-version-single-shroud)
* [Anker PowerCore Essential 20,000 PD Power Bank](https://smile.amazon.co.uk/gp/product/B08LG2X98F)

### Software config

[Raspberry Pi OS Buster 2021-05-28](https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2021-05-28/)
is needed for compatability with the PiTFT HAT. To get it to boot from SSD
the /boot/start4*.elf files are needed from a more recent Bullseye image.

**raspi-config**

Enable SSH, I2C, SPI, Uart (disable console on Uart).

**apt packages**

```
sudo apt-get update --allow-releaseinfo-change
sudo apt-get upgrade -y
sudo apt install i2c-tools git python3-pip curl libsdl2-mixer-2.0-0 \
  libsdl2-image-2.0-0 libsdl2-2.0-0 libgles2-mesa-dev libsdl2-ttf-2.0-0 \
  mosquitto mosquitto-clients minicom jq screen ppp
```

**pip3 packages**

```
sudo pip3 install smbus max30105 smbus2 pygame paho-mqtt i2cdevice
sudo pip3 install --upgrade adafruit-python-shell click
```

[TFT HAT easy install](https://learn.adafruit.com/adafruit-2-4-pitft-hat-with-resistive-touchscreen-mini-kit/easy-install)

The resultant config in /boot/config.txt is something like:

```
# --- added by adafruit-pitft-helper Tue Feb  8 14:31:08 2022 ---
#hdmi_force_hotplug=0
dtparam=spi=on
dtparam=i2c1=on
dtparam=i2c_arm=on
dtoverlay=pitft28-resistive,rotate=270,speed=64000000,fps=30
# --- end adafruit-pitft-helper Tue Feb  8 14:31:08 2022 ---
```

Also add these lines to avoid console being shown on TFT and hogging
framebuffer device when no HDMI monitor is connected:

```
hdmi_force_hotplug=1
hdmi_drive=2
```

**install Dart**

From the [Dart SDK archive](https://dart.dev/get-dart/archive):  
Stable channel : Linux : Armv7
