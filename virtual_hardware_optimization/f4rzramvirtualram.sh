#!/bin/bash
if [ "$EUID" -ne 0 ]; then 
  echo "ERROR: "
  exit 1
fi

echo "Plugetk: "
echo "Virtual Ram Creating..."
swapoff /dev/zram0 2>/dev/null
echo 1 > /sys/block/zram0/reset 2>/dev/null

modprobe zram
if grep -q zstd /sys/block/zram0/comp_algorithm; then
    echo zstd > /sys/block/zram0/comp_algorithm
elif grep -q lzo-rle /sys/block/zram0/comp_algorithm; then
    echo lzo-rle > /sys/block/zram0/comp_algorithm
else
    echo lzo > /sys/block/zram0/comp_algorithm
fi
echo 1536M > /sys/block/zram0/disksize
mkswap /dev/zram0
swapon -p 100 /dev/zram0

echo "--- Successful! ---"
echo "new ram:"
zramctl
