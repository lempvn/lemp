#!/bin/bash

# Lay phien ban Ubuntu
ubuntuVersion=$(lsb_release -rs)

# Ham kiem tra va chan IP neu ket noi qua nhieu
check_and_block_ip () {
    LIMIT=$1

    for ip in $(awk '{print $1}' /root/ebiplist); do
        # Kiem tra so luong ket noi tu IP
        if [ $(grep -c $ip /root/ebiplist) -gt $LIMIT ]; then
            # Thong bao va chan IP
            echo "Qua nhieu ket noi tu $ip... Auto block"

            # Chan IP bang iptables
            iptables -A INPUT -s $ip -j DROP
            
            # Luu cau hinh iptables
            iptables-save > /etc/iptables/rules.v4
            
            # Khoi dong lai iptables
            systemctl restart netfilter-persistent
            # Doi mot thoi gian de giam so ket noi
            sleep 30
        fi
    done
}

# Tao file luu danh sach IP
if [ ! -f /root/ebiplist ]; then
    touch /root/ebiplist
    chmod 644 /root/ebiplist
fi

# Gioi han so luong ket noi
LIMIT=250

# Kiem tra va thu thap danh sach dia chi IP ket noi den cong 80
netstat -plan | grep :80 | awk '{print $5}' | cut -d: -f 1 | sort | uniq -c | sort -nr | head > /root/ebiplist

check_and_block_ip $LIMIT

# Kiem tra va thu thap danh sach dia chi IP ket noi den cong 443
netstat -plan | grep :443 | awk '{print $5}' | cut -d: -f 1 | sort | uniq -c | sort -nr | head >> /root/ebiplist

check_and_block_ip $LIMIT

# Kiem tra va thu thap danh sach dia chi IP ket noi den cong NFS (2049)
netstat -plan | grep :2049 | awk '{print $5}' | cut -d: -f 1 | sort | uniq -c | sort -nr | head >> /root/ebiplist

check_and_block_ip $LIMIT

echo "Kiem tra va chan IP DDoS hoan tat"
sleep 5

# Goi script kiem tra DDoS khac (neu can thiet)
# /etc/lemp/menu/lemp-kiem-tra-ddos.sh
