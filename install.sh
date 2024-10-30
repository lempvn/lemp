#!/bin/sh

#cd ~
#if [ -d /opt/vps_lemp ]; then
#rm -rf /opt/vps_lemp/*
#rm -rf /opt/vps_lemp
#sleep 2
#fi

# check xem IPv6 co dang bat hay khong, neu co se tat no
echo "Script se tu dong tat IPv6 de tien hanh cai dat Lemp, ban co the bat lai sau khi cai xong LEMP"
echo "Dang tien hanh kiem tra va tat IPv6 neu dang bat..."
sleep 3
echo "-----------------------------------------------------------------"
# Kiem tra trang thai cua IPv6
ipv6_status=$(sysctl net.ipv6.conf.all.disable_ipv6 | awk '{print $3}')

# Neu IPv6 dang bat (ipv6_status = 0), tat no
if [ "$ipv6_status" -eq 0 ]; then
    echo "IPv6 dang bat. Dang tat IPv6..."
    # Vo hieu hoa IPv6
    sysctl -w net.ipv6.conf.all.disable_ipv6=1
    sysctl -w net.ipv6.conf.default.disable_ipv6=1
    sysctl -w net.ipv6.conf.lo.disable_ipv6=1
    echo "IPv6 da duoc tat."
    ipv6_status=1 # Cap nhat lai trang thai
else
    clear
    echo "========================================================================="
    echo "IPv6 da tat truoc do, khong can thay doi."
fi

# Cap nhat cau hinh sysctl de ap dung thay doi sau khi khoi dong lai
if grep -q "net.ipv6.conf.all.disable_ipv6" /etc/sysctl.conf; then
    # Neu da co dong nay thi thay doi gia tri
    sed -i "s/net.ipv6.conf.all.disable_ipv6 = .*/net.ipv6.conf.all.disable_ipv6 = $ipv6_status/" /etc/sysctl.conf
    sed -i "s/net.ipv6.conf.default.disable_ipv6 = .*/net.ipv6.conf.default.disable_ipv6 = $ipv6_status/" /etc/sysctl.conf
    sed -i "s/net.ipv6.conf.lo.disable_ipv6 = .*/net.ipv6.conf.lo.disable_ipv6 = $ipv6_status/" /etc/sysctl.conf
else
    # Neu chua co thi them vao
    echo "net.ipv6.conf.all.disable_ipv6 = $ipv6_status" >> /etc/sysctl.conf
    echo "net.ipv6.conf.default.disable_ipv6 = $ipv6_status" >> /etc/sysctl.conf
    echo "net.ipv6.conf.lo.disable_ipv6 = $ipv6_status" >> /etc/sysctl.conf
fi

# Ap dung lai cac thiet lap sysctl ngay lap tuc
sysctl -p > /dev/null 2>&1

echo "Qua trinh tat IPv6 da hoan tat."
echo "Tien hanh tai va cai dat LEMP"
echo "-----------------------------------------------------------------"
sleep 3



sudo apt update
# add repo cho mariadb
sudo mkdir -p /etc/apt/keyrings
sudo curl -o /etc/apt/keyrings/mariadb-keyring.pgp 'https://mariadb.org/mariadb_release_signing_key.pgp'
sudo DEBIAN_FRONTEND=noninteractive apt -yqq install apt-transport-https tar virt-what unzip sudo net-tools iproute2 wget curl
sudo DEBIAN_FRONTEND=noninteractive apt -yqq install lsb-release ca-certificates apt-transport-https software-properties-common

# add repo cho php
add-apt-repository ppa:ondrej/php -y
sudo apt update


mkdir -p /opt
cd /opt/

git clone https://github.com/lempvn/lemp.git vps_lemp


# chay lan luot cac lenh sau
find /opt/vps_lemp/script/lemp/menu -type f -exec chmod 755 {} \;
/opt/vps_lemp/script/lemp/menu/git-clone-done.sh

#echo "update LEMP menu"
mkdir -p /etc/lemp/menu ; chmod 755 /etc/lemp/menu
#rm -rf /etc/lemp/menu/*
yes | cp -rf /opt/vps_lemp/script/lemp/menu/. /etc/lemp/menu/

#echo "Chmod 755 Menu"
/opt/vps_lemp/script/lemp/menu/chmod-755-menu.sh


cd /opt/vps_lemp
chmod +x setup.sh
bash setup.sh
