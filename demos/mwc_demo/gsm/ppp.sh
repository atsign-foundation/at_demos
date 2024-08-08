#!/bin/bash
sudo pon a-gsm
sleep 10
sudo ifconfig ppp0 mtu 1200
sudo route add default dev ppp0