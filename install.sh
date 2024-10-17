#!/bin/sh

#cd ~
#if [ -d /opt/vps_lemp ]; then
#rm -rf /opt/vps_lemp/*
#rm -rf /opt/vps_lemp
#sleep 2
#fi

echo "Script se tu dong tat IPv6 de tien hanh cai dat Lemp, ban co the bat lai "

# check xem IPv6 có đang bật hay không, nếu có sẽ tắt nó


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


#
# Link tai goi cai dat lemp ve
# them sau....
# ....

# chuyển file vps_lemp vừa tải ở trên vào thư mục /opt/vps_lemp bằng lệnh: mv vps_lemp /opt/vps_lemp và giải nén nó


# chạy lần lượt các lệnh sau
find /opt/vps_lemp/script/lemp/menu -type f -exec chmod 755 {} \;
/opt/vps_lemp/script/lemp/menu/git-clone-done

#echo "update LEMP menu"
mkdir -p /etc/lemp/menu ; chmod 755 /etc/lemp/menu
#rm -rf /etc/lemp/menu/*
yes | cp -rf /opt/vps_lemp/script/lemp/menu/. /etc/lemp/menu/

#echo "Chmod 755 Menu"
/opt/vps_lemp/script/lemp/menu/chmod-755-menu


cd /opt/vps_lemp
chmod +x setup
bash setup