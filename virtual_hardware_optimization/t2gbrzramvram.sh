#!/bin/bash

# Root yetkisi kontrolü
if [ "$EUID" -ne 0 ]; then 
  echo "Lütfen bu betiği sudo ile çalıştırın."
  exit
fi

echo "Plugetk: "
echo "Virtual Ram creating... "

swapoff /dev/zram0 2>/dev/null
echo 1 > /sys/block/zram0/reset 2>/dev/null

modprobe zram
echo zstd > /sys/block/zram0/comp_algorithm 2>/dev/null || echo lzo > /sys/block/zram0/comp_algorithm
echo 1G > /sys/block/zram0/disksize
mkswap /dev/zram0
swapon -p 100 /dev/zram0

echo "! 1 GB of virtual RAM was created."
zramctl
