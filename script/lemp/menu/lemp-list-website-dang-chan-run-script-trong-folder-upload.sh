#!/bin/bash
. /home/lemp.conf
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
sleep 1
rm -rf /tmp/*vpsvn*
mkdir -p /tmp/sitedangdenyrunscriptvpsvn
ls /etc/nginx/conf.d > /tmp/lemp-websitelist
sed -i 's/\.conf//g' /tmp/lemp-websitelist 
sowebsitetrenserver=$(cat /tmp/lemp-websitelist | wc -l)
sowebsite=$(cat /tmp/lemp-websitelist)
for website in $sowebsite 
do
if [ -f /etc/nginx/conf.d/$website.conf ]; then
if [ "$(grep deny-script-writeable-folder.conf /etc/nginx/conf.d/$website.conf)" == "include /etc/nginx/conf/deny-script-writeable-folder.conf;" ]; then
touch /tmp/sitedangdenyrunscriptvpsvn/$website
fi
fi
if [ -f /etc/nginx/conf.d/www.$website.conf ]; then
if [ "$(grep deny-script-writeable-folder.conf /etc/nginx/conf.d/www.$website.conf)" == "include /etc/nginx/conf/deny-script-writeable-folder.conf;" ]; then
touch /tmp/sitedangdenyrunscriptvpsvn/www.$website
fi
fi
done
clear
echo "========================================================================="
echo "Website tren server: $sowebsitetrenserver"
echo "-------------------------------------------------------------------------"
if [ "$(ls -1 /tmp/sitedangdenyrunscriptvpsvn | wc -l)" == "0" ]; then
echo "Website KHONG CHO PHEP chay script trong writeable folder: 0"
else
echo "Website KHONG CHO PHEP chay script trong writeable folder: $(ls -1 /tmp/sitedangdenyrunscriptvpsvn | wc -l)"
echo "-------------------------------------------------------------------------"
ls /tmp/sitedangdenyrunscriptvpsvn | pr -3 -t
rm -rf /tmp/*vpsvn*
fi
/etc/lemp/menu/tienich/lemp-tien-ich.sh
