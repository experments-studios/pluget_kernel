#!/bin/bash
if [ "$EUID" -ne 0 ]; then 
  echo "ERROR: "
  exit 1
fi

echo "virtual ram creating..."
swapoff /dev/zram0 2>/dev/null
echo 1 > /sys/block/zram0/reset 2>/dev/null

modprobe zram
if grep -q zstd /sys/block/zram0/comp_algorithm; then
    echo zstd > /sys/block/zram0/comp_algorithm
    algo="zstd"
else
    echo lzo > /sys/block/zram0/comp_algorithm
    algo="lzo"
fi
echo 3G > /sys/block/zram0/disksize
mkswap /dev/zram0
swapon -p 100 /dev/zram0

echo "------------------------------------------"
echo "hardware ram: 8 GB"
echo "Algoritma: $algo"
echo "virtual ram: 3 GB"
echo "------------------------------------------"
zramctl
