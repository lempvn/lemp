#!/bin/sh

echo "Install git..."
sudo yum -y install git > /dev/null 2>&1

# update code
if [ -d /opt/vps_lemp ]; then
cd ~ ; cd /opt/vps_lemp && git pull origin main ; cd ~
#git pull origin master
#git pull origin
fi

cd ~

sleep 5

find /opt/vps_lemp/script/lemp/menu -type f -exec chmod 755 {} \;
/opt/vps_lemp/script/lemp/menu/git-clone-done

