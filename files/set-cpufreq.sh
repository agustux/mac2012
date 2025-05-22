#!/bin/bash
for cpu in /sys/devices/system/cpu/cpu[0-9]*; do
  # Check if this directory contains a cpufreq interface
  if [ -f "$cpu/cpufreq/scaling_governor" ]; then
    cpu_id="${cpu##*/cpu}"
    cpufreq-set -c "$cpu_id" -g performance
  fi
done
