#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "ERROR:"
   exit 1
fi

echo "virtual ram creating..."
swapoff /dev/zram0 2>/dev/null
echo 1 > /sys/block/zram0/reset 2>/dev/null
modprobe zram num_devices=1
echo zstd > /sys/block/zram0/comp_algorithm

echo 4G > /sys/block/zram0/disksize

mkswap /dev/zram0
swapon -p 100 /dev/zram0

echo "ram: 12GB"
echo "virtual ram: 4GB"
