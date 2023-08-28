#!/bin/bash
while true; do
  MWCHR=$(mosquitto_sub -h localhost -t "mqtt/mwc_hr" -C 1)
  at_cli -v update --key public:custom_mwc_hr.wavi --value "{\"label\":\"HR\",\"category\":\"MWC\",\"type\":\"Text\",\"value\":\"${MWCHR}\",\"valueLabel\":\"\"}"
  sleep 1
done
