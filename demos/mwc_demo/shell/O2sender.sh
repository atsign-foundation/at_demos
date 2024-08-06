#!/bin/bash
while true; do 
  mosquitto_pub -d -t "mqtt/mwc_o2" -m $(bc -l <<< "scale=1 ; $((RANDOM % 1000 ))/200  + 95")
  sleep 10
done
