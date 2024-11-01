#!/bin/bash
. /home/lemp.conf
php_version1=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")
rm -rf /tmp/checktmp
echo "Check /tmp by LEMP" > /tmp/checktmp
if [ ! -f /tmp/checktmp ]; then
clear
echo "========================================================================="
echo "Your Server has a problem with /tmp "
echo "-------------------------------------------------------------------------"
echo "Please fix it before use this function"
/etc/lemp/menu/lemp-update-upgrade-service-menu.sh
exit
fi
rm -rf /tmp/checktmp
change_phpmyadmin_run () {
cd  /home/$mainsite/private_html/
wget https://files.phpmyadmin.net/phpMyAdmin/${phpmyadmin_version}/phpMyAdmin-${phpmyadmin_version}-all-languages.zip
unzip phpMyAdmin-*.zip
yes | cp -rf phpMyAdmin-*/* .
rm -rf phpMyAdmin-*
rm -rf /home/$mainsite/private_html/config.inc.php
randomblow=`date |md5sum |cut -c '1-32'`;
sed -e "s|cfg\['blowfish_secret'\] = ''|cfg['blowfish_secret'] = '$randomblow'|" config.sample.inc.php > config.inc.php
cd
chown -R nginx:nginx /home/$mainsite/private_html
echo "${phpmyadmin_version}" > /etc/lemp/phpmyadmin.version
}

curTime=$(date +%d)
fileTime2=""
if [ -f /tmp/00-all-phpmyadmin-version.txt ]; then
fileTime2=$(date -r /tmp/00-all-phpmyadmin-version.txt +%d)
fi
#echo $curTime
#echo $fileTime2

if [ ! "$curTime" = "$fileTime2" ]; then
echo "Download 0-all-phpmyadmin-version.txt..."
cd /tmp
rm -rf 00-all-phpmyadmin-version*
wget --no-check-certificate -q https://raw.githubusercontent.com/vpsvn/lemp-version-2/main/script/lemp/00-all-phpmyadmin-version.txt
fi

cd ~

new_phpmyadmin_version=""
if [ -f /tmp/00-all-phpmyadmin-version.txt ]; then
new_phpmyadmin_version=`cat /tmp/00-all-phpmyadmin-version.txt | awk 'NR==2 {print $1}' | sed 's/|//' | sed 's/|//'`
#echo $new_phpmyadmin_version
fi

echo "========================================================================="
echo "Su dung chuc nang nay de cai dat phpMyAdmin phien ban tuy chon"
echo "-------------------------------------------------------------------------"

if [ -f /etc/lemp/phpmyadmin.version ]; then
echo "Current phpmyadmin version: "$(cat /etc/lemp/phpmyadmin.version)
echo "-------------------------------------------------------------------------"
fi

echo "Xem list cac phien ban phpMyAdmin tai: https://phpmyadmin.net/files/"
echo "-------------------------------------------------------------------------"

if [ ! "$new_phpmyadmin_version" = "" ]; then
echo "Recommended version: "$new_phpmyadmin_version
echo "-------------------------------------------------------------------------"
fi

echo -n "Nhap phien ban phpMyAdmin ban muon su dung (y = "$new_phpmyadmin_version") [ENTER]: " 
read phpmyadmin_version

if [ "$phpmyadmin_version" = "y" ]; then
phpmyadmin_version=$new_phpmyadmin_version
fi

if [ "$phpmyadmin_version" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai!"
/etc/lemp/menu/lemp-update-upgrade-service-menu.sh
exit
fi

if  [ "$php_version1" == "5.4" ]; then
echo "$phpmyadmin_version" > /tmp/lemp_phpmyadminforphp54
 if [ "$(grep 4.4.15 /tmp/lemp_phpmyadminforphp54)" == "" ]; then
rm -rf /tmp/lemp_phpmyadminforphp54
clear 
echo "========================================================================="
echo "Ban dang su dung PHP 5.4, ban chi co the su dung phpMyAdmin 4.4.15.X"
echo "-------------------------------------------------------------------------"
echo "Vui long chon lai phien ban phpMyAdmin"
/etc/lemp/menu/lemp-update-upgrade-service-menu.sh
exit 
fi
fi
if [ "$phpmyadmin_version" = "1.1.0" ] || [ "$phpmyadmin_version" = "1.3.0" ] || [ "$phpmyadmin_version" = "2.0.5" ] || [ "$phpmyadmin_version" = "2.1.0" ] || [ "$phpmyadmin_version" = "2.11.10.1" ] || [ "$phpmyadmin_version" = "2.11.11" ] || [ "$phpmyadmin_version" = "2.11.11.2" ] || [ "$phpmyadmin_version" = "2.11.11.3" ] || [ "$phpmyadmin_version" = "3.3.5.1" ] || [ "$phpmyadmin_version" = "3.3.6" ] || [ "$phpmyadmin_version" = "3.3.7" ] || [ "$phpmyadmin_version" = "3.3.8" ] || [ "$phpmyadmin_version" = "3.3.8.1" ] || [ "$phpmyadmin_version" = "3.3.9" ] || [ "$phpmyadmin_version" = "3.3.9.1" ] || [ "$phpmyadmin_version" = "3.3.9.2" ] || [ "$phpmyadmin_version" = "3.3.10" ] || [ "$phpmyadmin_version" = "3.3.10.1" ] || [ "$phpmyadmin_version" = "3.3.10.2" ] || [ "$phpmyadmin_version" = "3.3.10.3" ] || [ "$phpmyadmin_version" = "3.3.10.4" ] || [ "$phpmyadmin_version" = "3.3.10.5" ] || [ "$phpmyadmin_version" = "3.4.0" ] || [ "$phpmyadmin_version" = "3.4.1" ] || [ "$phpmyadmin_version" = "3.4.2" ] || [ "$phpmyadmin_version" = "3.4.3" ] || [ "$phpmyadmin_version" = "3.4.3.1" ] || [ "$phpmyadmin_version" = "3.4.3.2" ] || [ "$phpmyadmin_version" = "3.4.4" ] || [ "$phpmyadmin_version" = "3.4.5" ] || [ "$phpmyadmin_version" = "3.4.6" ] || [ "$phpmyadmin_version" = "3.4.7" ] || [ "$phpmyadmin_version" = "3.4.7.1" ] || [ "$phpmyadmin_version" = "3.4.8" ] || [ "$phpmyadmin_version" = "3.4.9" ] || [ "$phpmyadmin_version" = "3.4.10" ] || [ "$phpmyadmin_version" = "3.4.10.1" ] || [ "$phpmyadmin_version" = "3.4.10.2" ] || [ "$phpmyadmin_version" = "3.4.11" ] || [ "$phpmyadmin_version" = "3.5.0" ] || [ "$phpmyadmin_version" = "3.5.2" ] || [ "$phpmyadmin_version" = "3.5.3" ] || [ "$phpmyadmin_version" = "3.5.4" ] || [ "$phpmyadmin_version" = "3.5.5" ] || [ "$phpmyadmin_version" = "3.5.6" ] || [ "$phpmyadmin_version" = "3.5.7" ] || [ "$phpmyadmin_version" = "3.5.8" ] || [ "$phpmyadmin_version" = "3.5.8.1" ]; then
clear
echo "========================================================================="
echo "Phien ban phpMyAdmin ban nhap qua cu"
echo "-------------------------------------------------------------------------"
echo "Ban vui long chon phien ban phpMyAmin tu 4.0 tro len."
/etc/lemp/menu/lemp-update-upgrade-service-menu.sh
exit
fi
if [ -f /etc/lemp/phpmyadmin.version ]; then
phpmyadinhientai=`cat /etc/lemp/phpmyadmin.version`
else
phpmyadinhientai=Unknown
fi
if [[ "$phpmyadinhientai" == "$phpmyadmin_version" ]]; then
clear
echo "========================================================================="
echo "Ban dang su dung phpMyAdmin phien ban $phpmyadmin_version "
/etc/lemp/menu/lemp-update-upgrade-service-menu.sh
exit
fi
echo "-------------------------------------------------------------------------"
echo "Check phien ban phpMyAdmin ban nhap ..."
checkurlstt=$(curl -o /dev/null --silent --head --write-out '%{http_code}' "https://files.phpmyadmin.net/phpMyAdmin/${phpmyadmin_version}/phpMyAdmin-${phpmyadmin_version}-all-languages.zip" )
if [[ "$checkurlstt" == "404" ]]; then
clear
echo "========================================================================="
echo "Khong tim thay phpMyAdmin phien ban $phpmyadmin_version tren phpmyadmin.net"
echo "-------------------------------------------------------------------------"
echo "Ban vui long nhap lai !"
/etc/lemp/menu/lemp-update-upgrade-service-menu.sh
exit
fi
if [[ "$checkurlstt" == "000" ]]; then
clear
echo "========================================================================="
echo "Khong ket noi duoc phpmyadmin.net"
echo "-------------------------------------------------------------------------"
echo "Ban vui long kiem tra lai ket noi internet cua server !"
/etc/lemp/menu/lemp-update-upgrade-service-menu.sh
exit
fi
echo "-------------------------------------------------------------------------"
echo "Tim thay phpMyAdmin phien ban $phpmyadmin_version tren phpmyadmin.net"
echo "-------------------------------------------------------------------------"
echo "Phien ban phpMyAdmin ban dang su dung: $phpmyadinhientai"
echo "-------------------------------------------------------------------------"
echo "LEMP se thay the phien ban $phpmyadinhientai bang phien ban $phpmyadmin_version"
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
sleep 3
change_phpmyadmin_run

for service in $(systemctl list-units --type=service --state=running | grep php | awk '{print $1}'); do
    systemctl restart $service
done
systemctl restart nginx.service

clear
echo "========================================================================="
echo "Cai dat phpMyAdmin phien ban $phpmyadmin_version thanh cong!"
echo "Please login phpMyAdmin now and check ERROR if you want"
echo "http://"$serverip":"$priport
echo "root/"$mariadbpass
/etc/lemp/menu/lemp-update-upgrade-service-menu.sh
exit

