#!/bin/bash

. /home/lemp.conf
serverversion=`/root/.acme.sh/acme.sh --version | awk 'NR==2' | sed 's/v//'`
echo "========================================================================="
echo "Check Update Version ..."; sleep 3
rm -rf /etc/lemp/.tmp/checkupdate_acme.sh
mkdir -p /etc/lemp/.tmp/checkupdate_acme.sh
cd /etc/lemp/.tmp/checkupdate_acme.sh
wget -q https://codeload.github.com/Neilpang/acme.sh/zip/master
unzip -q master
airversion=$(grep VER= /etc/lemp/.tmp/checkupdate_acme.sh/acme.sh-master/acme.sh | sed 's/VER=//')
rm -rf /etc/lemp/.tmp/checkupdate_acme.sh
cd

if [ "$serverversion" = "$airversion" ]; then
clear
echo "========================================================================="
echo "Ban dang su dung phien ban moi nhat acme.sh ."
echo "-------------------------------------------------------------------------"
echo "Version: $serverversion"
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
fi
clear
echo "========================================================================="
/root/.acme.sh/acme.sh --upgrade
version=`/root/.acme.sh/acme.sh --version | awk 'NR==2' | sed 's/v//'`
echo "-------------------------------------------------------------------------"
echo "Lastest Version: $version"
rm -rf /etc/lemp/.tmp/check_crontab_acme
crontab -l > /etc/lemp/.tmp/check_crontab_acme
if [ ! "$(grep "/root/.acme.sh" /etc/lemp/.tmp/check_crontab_acme)" = "" ]; then
/root/.acme.sh/acme.sh --uninstallcronjob
fi
rm -rf /etc/lemp/.tmp/check_crontab_acme
sleep 3
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
