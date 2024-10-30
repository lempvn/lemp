#!/bin/bash
. /home/lemp.conf

# copy code tu file install sang
cd ~
wget --no-check-certificate -q https://raw.githubusercontent.com/vpsvn/lemp-version-2/main/script/lemp/menu/git-clone
chmod +x /root/git-clone
bash /root/git-clone


# BEGIN update LEMP main
#rm -rf /etc/motd
yes | cp -rf /opt/vps_lemp/script/lemp/motd /etc/motd

yes | cp -rf /opt/vps_lemp/script/lemp/calc /bin/calc && chmod +x /bin/calc

yes | cp -rf /opt/vps_lemp/script/lemp/lemp /bin/lemp && chmod +x /bin/lemp
# BEGIN update LEMP main


rm -rf /home/lemp.demo/errorpage_html/*
yes | cp -rf /opt/vps_lemp/script/lemp/errorpage_html/. /home/lemp.demo/errorpage_html/


# BEGIN update LEMP menu
#rm -rf /etc/lemp/menu/*
#yes | cp -rf /opt/vps_lemp/script/lemp/menu/. /etc/lemp/menu/

# Chmod 755 Menu
#/opt/vps_lemp/script/lemp/menu/chmod-755-menu
# END update LEMP menu


# confirm done update
yes | cp -rf /opt/vps_lemp/version /etc/lemp/lemp.version


#rm -rf /opt/vps_lemp/*
#rm -rf /opt/vps_lemp
sleep 1

# enable auto update system
if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "7" ]; then
if [ -f /etc/lemp/menu/auto-update-system.sh ]; then
clear && bash /etc/lemp/menu/auto-update-system.sh
fi
else
echo "Auto update system in CentOS 7 only"
/etc/lemp/menu/lemp-update-upgrade-service-menu.sh
fi

#exit
