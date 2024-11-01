#!/bin/bash
. /home/lemp.conf
rm -rf /tmp/*vpsvn*
mkdir -p /tmp/sitedangbatpagespeedvpsvn
ls /etc/nginx/conf.d > /tmp/lemp-websitelist
sed -i 's/\.conf//g' /tmp/lemp-websitelist 
sowebsitetrenserver=$(cat /tmp/lemp-websitelist | wc -l)
websitetrenserver=$(cat /tmp/lemp-websitelist)
for website in $websitetrenserver 
do
if [ "$(grep "ngx_pagespeed.conf" /etc/nginx/conf.d/$website.conf)" == "include /etc/nginx/ngx_pagespeed.conf;" ]; then
touch /tmp/sitedangbatpagespeedvpsvn/$website
fi
done
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
sleep 1
clear
echo "========================================================================="
echo "Website tren server: $sowebsitetrenserver"
echo "-------------------------------------------------------------------------"
if [ "$(ls -1 /tmp/sitedangbatpagespeedvpsvn | wc -l)" == "0" ]; then
echo "Website Enabled Nginx Pagespeed: 0"
else
echo "Website dang Bat Nginx Pagespeed: $(ls -1 /tmp/sitedangbatpagespeedvpsvn | wc -l)"
echo "-------------------------------------------------------------------------"
ls /tmp/sitedangbatpagespeedvpsvn | pr -3 -t
fi
rm -rf /tmp/*vpsvn*
rm -rf /tmp/*lemp*
/etc/lemp/menu/pagespeed/lemp-pagespeed-menu.sh

