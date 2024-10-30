#!/bin/bash

. /home/lemp.conf

echo "========================================================================="
echo "Su dung chuc nang nay de kiem tra SSL status cho website cai dat SSL"
echo "-------------------------------------------------------------------------"
echo -n "Nhap ten website [ENTER]: " 
read website
website=`echo $website | tr '[A-Z]' '[a-z]'`
websiteTO=`echo $website | tr '[a-z]' '[A-Z]'`
if [ "$website" = "" ]; then
clear
echo "========================================================================="
echo "Ban chua nhap ten website"
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
exit
fi

if [ ! -f /etc/nginx/conf.d/$website.conf ]; then
clear
echo "========================================================================="
echo "Khong tim thay $website tren server "
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
exit
fi  

if [ ! -d /home/$website/public_html ]; then
clear
echo "========================================================================="
echo "Khong tim thay folder public_html cua $website"
echo "-------------------------------------------------------------------------"
echo "LEMP khong the thuc hien thuc nang nay."
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
exit
fi
##############

if [ ! -f /root/.acme.sh/${website}_ecc/$website.conf ]; then
clear
echo "========================================================================="
echo "$website chua duoc cai dat SSL Let's Encrypt."
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
exit
fi

if [ -f /root/.acme.sh/${website}_ecc/$website.conf ]; then

echo "Check $website when Setup SSL" > /home/$website/public_html/lemp.check
checkurlsttSSL=$(curl -o /dev/null --silent --head --write-out '%{http_code}' "https://$website/lemp.check")
checkurlstt=$(curl -o /dev/null --silent --head --write-out '%{http_code}' "http://$website/lemp.check")
rm -rf /home/$website/public_html/lemp.check

if [[  "$checkurlsttSSL" == "200" ]]; then
echo "-------------------------------------------------------------------------"
echo "Please wait ..." 
sleep 2
#nextgiahan=`cat /root/.acme.sh/${website}_ecc/$website.conf | grep NextRenewTimeStr | cut -d \" -f 2 `
#curTime=$(date +%s)
#thoigiangiahangiay=`cat /root/.acme.sh/${website}_ecc/$website.conf | grep Le_NextRenewTime= | cut -d \" -f 2`
#hieuthoigianconlai=$(calc $thoigiangiahangiay-$curTime)
#thoigiannengiahanlai=$(calc $hieuthoigianconlai/60/60/24)
#thoigianconlai=$(calc $thoigiannengiahanlai+10)
#-----------------------------Check SSL-----------------------------------------
check_ssl () {
	data=`echo | openssl s_client -servername $website -connect $website:${2:-443} 2>/dev/null | 
openssl x509 -noout -enddate | sed -e 's#notAfter=##'`
	ssldate=`date -d "${data}" '+%s'`
	nowdate=`date '+%s'`
	diff="$((${ssldate}-${nowdate}))"
	echo $((${diff}/86400))
}
thoigianconlai=$(check_ssl $website)
thoigiannengiahanlai=$(calc $thoigianconlai-10)
#-------------------------------------------------------------------------------
clear
echo "========================================================================="
echo "$websiteTO da cai dat thanh cong SSL Let's Encrypt."
echo "-------------------------------------------------------------------------"
echo "Chung chi SSL het han sau: $thoigianconlai ngay."
if [ -f /etc/lemp/Renew.SSL.Letencrypt ] && [ -f /etc/cron.d/lemp.autorenew.ssl.cron ]; then
echo "-------------------------------------------------------------------------"
echo "LEMP se tu dong gia han chung chi sau: $thoigiannengiahanlai ngay."
else
echo "-------------------------------------------------------------------------"
echo "BAN CHUA BAT TINH NANG TU DONG GIA HAN SSL."
fi
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
exit
fi

if [[ "$checkurlstt" == "200" ]]; then

yes | cp -rf  /etc/lemp/Backup.Vhost.SSL/$website/$website.conf /home/$website/$website.conf_HTTP
yes | cp -rf  /etc/lemp/Backup.Vhost.SSL/$website/$website.conf_HTTPS /home/$website/$website.conf_HTTPS
echo "-------------------------------------------------------------------------"
echo "Please wait ..." 
sleep 2
clear
echo "========================================================================="
echo "Ban da tao chung chi SSL cho $websiteTO nhung chua cai dat thanh cong"
echo "-------------------------------------------------------------------------"
echo "Ban phai tu edit Vhost cua $websiteTO theo thong tin duoi:"
echo "-------------------------------------------------------------------------"
echo "File Vhost: /etc/nginx/conf.d/$website.conf"
echo "-------------------------------------------------------------------------"
echo "Backup Vhost: /home/$website/$website.conf_HTTP"
echo "-------------------------------------------------------------------------"
echo "SSL Vhost: /home/$website/$website.conf_HTTPS"
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
exit
fi
fi

