#!/bin/bash

. /home/lemp.conf

echo "========================================================================="
echo "Su dung chuc nang nay de gia han chung chi SSL (Let's Encrypt)."
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

echo "Check $website when Setup SSL" > /home/$website/public_html/lemp.check
checkurlsttSSL=$(curl -o /dev/null --silent --head --write-out '%{http_code}' "https://$website/lemp.check")
checkurlstt=$(curl -o /dev/null --silent --head --write-out '%{http_code}' "http://$website/lemp.check")
rm -rf /home/$website/public_html/lemp.check

if [ ! "$checkurlstt" = "200" ] && [ ! "$checkurlsttSSL" = "200" ]; then
clear
echo "========================================================================="
echo "Ban chua tro $website toi $serverip"
echo "-------------------------------------------------------------------------"
echo "LEMP khong the thuc hien chuc nang nay."
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
fi

if [ "$(grep "/etc/nginx/auth-acme/$website/$website.crt" /etc/nginx/conf.d/$website.conf)" = "" ] && [ "$checkurlsttSSL" == "200" ]; then
clear
echo "========================================================================="
echo "$websiteTO co cai dat SSL nhung khong su dung Let's Encrypt."
echo "-------------------------------------------------------------------------"
echo "LEMP khong the thuc hien chuc nang nay."
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
exit
fi

if [ ! "$(grep "/etc/nginx/auth-acme/$website/$website.crt" /etc/nginx/conf.d/$website.conf)" = "" ] && [ "$checkurlsttSSL" == "200" ]; then
#---------------------------------------- Function Check SSL ---------------------------------------
check_ssl () {
	data=`echo | openssl s_client -servername $website -connect $website:${2:-443} 2>/dev/null |
	openssl x509 -noout -enddate | sed -e 's#notAfter=##'`
	ssldate=`date -d "${data}" '+%s'`
	nowdate=`date '+%s'`
	diff="$((${ssldate}-${nowdate}))"
	echo $((${diff}/86400))
}
thoigianconlai=$(check_ssl $website)
#----------------------------------------------------------------------------------------------------

if [ "$thoigianconlai" -lt 10 ]; then
echo "------------------------------------------------------------------------"
echo "Chung chi SSL cho $website con thoi han: $thoigianconlai ngay"
echo "------------------------------------------------------------------------"
echo "LEMP se tien hanh gia han chung chi nay."
echo "------------------------------------------------------------------------"
echo "Please wait ..."; sleep 3
/root/.acme.sh/acme.sh --renew --domain $website -f

thoigianconlai2=$(check_ssl $website)
clear
echo "========================================================================="
echo "Hoan thanh gia han chung chi SSL cho $website."
echo "-------------------------------------------------------------------------"
echo "Chung chi se het han sau: $thoigianconlai2 ngay."
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
fi

if [ "$thoigianconlai" -gt 10 ] && [ "$thoigianconlai" -lt 60 ]; then
echo "========================================================================="
echo "Chung chi SSL cho $website con thoi han $thoigianconlai ngay."
echo "-------------------------------------------------------------------------"
echo "Thoi han nay > 10 ngay."
echo "========================================================================="
  read -r -p "Ban van muon gia han chung chi SSL cho $website ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "-------------------------------------------------------------------------"
echo "Please wait ..."; sleep 3
/root/.acme.sh/acme.sh --renew --domain $website -f
curTime2=$(date +%s)
thoigiangiahangiay2=`cat /root/.acme.sh/${website}_ecc/$website.conf | grep Le_NextRenewTime= | cut -d \" -f 2`
hieuthoigianconlai2=$(calc $thoigiangiahangiay2-$curTime)
thoigiannengiahan2=$(calc $hieuthoigianconlai2/60/60/24)
thoigianconlai2=$(calc $thoigiannengiahan2+10)
clear
echo "========================================================================="
echo "Hoan thanh gia han chung chi SSL Let's Encrypt."
echo "-------------------------------------------------------------------------"
echo "Chung chi se het han sau: $thoigianconlai2 ngay."
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
;;
    *)
clear 
echo "========================================================================= "
echo "Cancel !"
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
        ;;
esac
fi

if [ "$thoigianconlai" -gt 61 ]; then
clear 
echo "========================================================================= "
echo "Thoi Han chung chi SSL cua $website con $thoigianconlai ngay."
echo "-------------------------------------------------------------------------"
echo "Ban chua can chay chuc nang nay."
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
fi
fi

if [ -f /root/.acme.sh/${website}_ecc/$website.conf ] && [ "$checkurlstt" == "200" ]; then
yes | cp -rf  /etc/lemp/Backup.Vhost.SSL/$website/$website.conf /home/$website/$website.conf_HTTP
yes | cp -rf  /etc/lemp/Backup.Vhost.SSL/$website/$website.conf_HTTPS /home/$website/$website.conf_HTTPS
clear
echo "========================================================================="
echo "Ban da tao chung chi SSL cho $website nhung chua cai dat thanh cong"
echo "-------------------------------------------------------------------------"
echo "Ban phai tu edit Vhost cua $website theo thong tin duoi:"
echo "-------------------------------------------------------------------------"
echo "File Vhost: /etc/nginx/conf.d/$website.conf"
echo "-------------------------------------------------------------------------"
echo "Backup Vhost: /home/$website/$website.conf_HTTP"
echo "-------------------------------------------------------------------------"
echo "SSL Vhost: /home/$website/$website.conf_HTTPS"
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
exit
fi

if [ ! -f /root/.acme.sh/${website}_ecc/$website.conf ] && [ "$checkurlstt" == "200" ]; then
clear
echo "========================================================================="
echo "Ban chu cai dat SSL Let's Encrypt cho $website !"
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
exit
fi
