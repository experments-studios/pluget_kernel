#!/bin/bash

# Root yetkisi kontrolü
if [ "$EUID" -ne 0 ]; then 
  echo "ERROR:"
  exit 1
fi

echo "virtual ram creating..."
swapoff /dev/zram0 2>/dev/null
echo 1 > /sys/block/zram0/reset 2>/dev/null
modprobe zram
if grep -q zstd /sys/block/zram0/comp_algorithm; then
    echo zstd > /sys/block/zram0/comp_algorithm
    echo "Sıkıştırma algoritması: zstd"
else
    echo lzo > /sys/block/zram0/comp_algorithm
    echo "zram not found: ERROR"
fi
echo 2G > /sys/block/zram0/disksize
mkswap /dev/zram0
swapon -p 100 /dev/zram0

echo "------------------------------------------"
echo "Virtual Ram: 2GB"
zramctl
echo "------------------------------------------"
