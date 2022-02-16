<img src="https://atsign.dev/assets/img/@dev.png?sanitize=true">

### Now for a little internet optimism

# Mobile World Congress Demo

This repo holds the files for The @ Company and Zariot demo for MWC 2022.

## at_cli

A simple script to use the at_cli tool to read from MQTT and send updates to
an @ sign.

## dart/iot_sender

A dart app to read from MQTT and send to an @ sign.

First modify `lib/config/config.yaml` to hold the correct location for the
sending @ sign .atKeys file.

```bash
cd dart/iot_sender
dart pub get
dart run ./bin/iot_sender.dart "@sendingatsign" "@receivingatsign"
```

## flutter/iot_receiver

A flutter app to receive data from dart/iot_sender and display it on dials.

To run the Windows version:

```
cd flutter/iot_receiver
flutter pub get
flutter run -d windows
```

## python

### hrmqttsolcd.py

Reads data from MAX30101 sensor then puts it onto MQTT queue whilst also
printing out values to local LCD display using pygame

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

**apt packages**

```
sudo apt-get update --allow-releaseinfo-change
sudo apt-get upgrade -y
suod apt install i2c-tools git python3-pip curl libsdl2-mixer-2.0-0 \
  libsdl2-image-2.0-0 libsdl2-2.0-0 libgles2-mesa-dev libsdl2-ttf-2.0-0 \
  mosquitto mosquitto-clients minicom jq screen
```

**pip3 packages**

```
sudo pip3 install smbus max30105 smbus2 pygame paho-mqtt i2cdevice
sudo pip3 install --upgrade adafruit-python-shell click
```

[TFT HAT easy install](https://learn.adafruit.com/adafruit-2-4-pitft-hat-with-resistive-touchscreen-mini-kit/easy-install)