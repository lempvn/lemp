#!/bin/bash

# Kiem tra neu file minfreedisc.info ton tai, neu khong thi tao no voi gia tri mac dinh
if [ ! -f /etc/lemp/minfreedisc.info ]; then
  echo "1000" > /etc/lemp/minfreedisc.info
fi

# Lay gia tri minfreedisc
minfreedisc=$(cat /etc/lemp/minfreedisc.info)

# Kiem tra gia tri co phai la so hop le khong
if ! [[ "$minfreedisc" =~ ^[0-9]+$ ]]; then
  echo "1000" > /etc/lemp/minfreedisc.info
fi

# Tao file /tmp/checkdiscsize neu chua ton tai
if [ ! -f /tmp/checkdiscsize ]; then
  touch /tmp/checkdiscsize
fi

# Lay ngay cua file /tmp/checkdiscsize
fileTime3=$(stat -c %d /tmp/checkdiscsize)
curTime=$(date +%d)

# So sanh ngay cua file voi ngay hien tai
if [ "$fileTime3" != "$curTime" ]; then
  touch /tmp/checkdiscsize

  # Tinh dung luong dia trong
  disfree=$(df $PWD | awk '/[0-9]%/{print int($(NF-2)/1024)}')
  echo "========================================================================="
  echo "Hien tai server con $disfree MB dung luong trong."
  echo "========================================================================="

  # Kiem tra gia tri disfree co phai la so hop le khong
  if [[ "$disfree" =~ ^[0-9]+$ ]]; then
    # So sanh dung luong trong voi gia tri minfreedisc
    if [ "$disfree" -lt "$minfreedisc" ]; then
      echo "========================================================================="
      echo "CANH BAO: Hien tai server chi con $disfree MB dung luong trong !"
    fi
  fi
fi
