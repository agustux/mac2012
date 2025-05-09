#!/bin/bash
# Description: Set fan speed to 4650 rpm upon awakening
case "$1" in
  post)
    echo 4650 | sudo tee /sys/devices/platform/applesmc.768/fan1_min
    ;;
esac