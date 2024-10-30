#!/bin/sh

cd ~
if [ -d /opt/vps_lemp ]; then
rm -rf /opt/vps_lemp/*
rm -rf /opt/vps_lemp
sleep 5
fi

echo "Install git..."
sudo yum -y install git > /dev/null 2>&1

# update code
if [ -d /opt/vps_lemp ]; then
cd ~ ; cd /opt/vps_lemp && git pull ; cd ~
#git commit -m "LEMP commit"
#git pull origin master
#git pull origin
#git merge origin master
# or clone new
else
git clone https://github.com/vpsvn/lemp-version-2.git /opt/vps_lemp
fi

cd ~

sleep 5

find /opt/vps_lemp/script/lemp/menu -type f -exec chmod 755 {} \;
/opt/vps_lemp/script/lemp/menu/git-clone-done

echo "update LEMP menu"
mkdir -p /etc/lemp/menu ; chmod 755 /etc/lemp/menu
rm -rf /etc/lemp/menu/*
yes | cp -rf /opt/vps_lemp/script/lemp/menu/. /etc/lemp/menu/

echo "Chmod 755 Menu"
/opt/vps_lemp/script/lemp/menu/chmod-755-menu
