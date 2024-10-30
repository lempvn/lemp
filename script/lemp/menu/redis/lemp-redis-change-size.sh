#!/bin/bash 
. /home/lemp.conf

# Kiem tra xem Redis co dang chay khong
if [ "$(redis-cli ping)" != "PONG" ]; then
    clear
    echo "========================================================================="
    echo "Redis dang dung."
    echo "-------------------------------------------------------------------------"
    echo "Ban phai bat Redis len bang lenh [ systemctl start redis ]"
    /etc/lemp/menu/redis/lemp-redis-menu.sh
    exit
fi

echo "========================================================================="
echo "Chuc nang nay cau hinh luong RAM lon nhat (MAX RAM) Redis co the su dung"
echo "-------------------------------------------------------------------------"
echo "Max RAM la so tu nhien nam trong khoang (40 - $(calc $( free -m | awk 'NR==2 {print $2}')/5))."
echo "-------------------------------------------------------------------------"
echo -n "Nhap luong RAM lon nhat cho Redis [ENTER]: " 
read maxredis

# Kiem tra xem nguoi dung co nhap gi khong
if [ -z "$maxredis" ]; then
    clear
    echo "========================================================================="
    echo "Ban nhap sai, vui long nhap lai."
    /etc/lemp/menu/redis/lemp-redis-menu.sh
    exit
fi

# Kiem tra xem gia tri RAM co hop le khong
if ! [[ $maxredis -ge 40 && $maxredis -le $(calc $( free -m | awk 'NR==2 {print $2}')/5) ]]; then  
    clear
    echo "========================================================================="
    echo "$maxredis khong hop le!"
    echo "-------------------------------------------------------------------------"
    echo "RAM cho Redis phai la so tu nhien nam trong khoang (40 - $(calc $( free -m | awk 'NR==2 {print $2}')/5))."
    /etc/lemp/menu/redis/lemp-redis-menu.sh
    exit
fi  

echo "-------------------------------------------------------------------------"
echo "Vui long cho ....."
sleep 1

# Ghi cau hinh vao tep redis.conf
# Thay doi gia tri maxmemory trong tep redis.conf
if grep -q "^[^#]*maxmemory" /etc/redis/redis.conf; then
    sed -i "s/^[^#]*maxmemory .*/maxmemory ${maxredis}mb/" /etc/redis/redis.conf
else
    echo "maxmemory ${maxredis}mb" >> /etc/redis/redis.conf
fi

if ! grep -q "^maxmemory-policy" /etc/redis/redis.conf; then
    sed -i "1s/^/maxmemory-policy allkeys-lru\n/" /etc/redis/redis.conf
fi

# Khoi dong lai dich vu Redis
systemctl restart redis

clear
echo "========================================================================="
echo "Cau hinh Max RAM cho Redis thanh cong"
echo "-------------------------------------------------------------------------"
echo "Redis co the su dung luong RAM toi da la: $maxredis MB "
/etc/lemp/menu/redis/lemp-redis-menu.sh
