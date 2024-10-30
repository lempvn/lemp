#!/bin/bash

. /home/lemp.conf
if [ ! -f /etc/lemp/menu/23_ssl-free/lemp-remove-ssl-letsencrypt-read.sh ]; then
clear
printf "=========================================================================\n"
printf "               LEMP - Quan Ly VPS/Server by LEMP.VN \n"
printf "=========================================================================\n"
printf "                      Cai Dat SSL - Let's Encrypt \n"
echo "========================================================================="
echo ""
echo "Ban can can nhac truoc khi su dung chuc nang nay."
echo "-------------------------------------------------------------------------"
echo "Khi chuyen tu HTTP => HTTPS, tat ca backlink duoc giu nguyen nhung neu"
echo "-------------------------------------------------------------------------"
echo "chuyen HTTPS nguoc tro lai HTTP, toan bo backlink cua website co duoc "
echo "-------------------------------------------------------------------------"
echo "sau khi su dung HTTPS se bi mat."
echo "-------------------------------------------------------------------------"
echo "THONG BAO NAY CHI XUAT HIEN MOT LAN DUY NHAT !"
echo "========================================================================="
touch /etc/lemp/menu/23_ssl-free/lemp-remove-ssl-letsencrypt-read.sh
read -p "Nhan [Enter] de tiep tuc ..."
clear
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
fi
echo "========================================================================="
echo "Su dung chuc nang nay de remove SSL (Let's Encrypt) hay quay tro lai HTTP"
echo "-------------------------------------------------------------------------"
echo "tu HTTPS cho Domain da setup SSL by Let's Encrypt bang LEMP."
echo "-------------------------------------------------------------------------"
echo -n "Nhap ten domain [ENTER]: " 
read website
website=`echo $website | tr '[A-Z]' '[a-z]'`
websiteTO=`echo $website | tr '[a-z]' '[A-Z]'`
if [ "$website" = "" ]; then
clear
echo "========================================================================="
echo "Ban chua nhap ten domain."
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
exit
fi

if [ ! -f /etc/nginx/conf.d/$website.conf ]; then
clear
echo "========================================================================="
echo "Khong tim thay $websiteTO tren server. "
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
exit
fi  

if [ ! -d /home/$website/public_html ]; then
clear
echo "========================================================================="
echo "Khong tim thay folder public_html cua  $website"
echo "-------------------------------------------------------------------------"
echo "Ban khong the su dung chuc nang nay."
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
exit
fi
##############

echo "Check $website SSL" > /home/$website/public_html/lemp.check
checkurlsttSSL=$(curl -o /dev/null --silent --head --write-out '%{http_code}' "https://$website/lemp.check")
checkurlstt=$(curl -o /dev/null --silent --head --write-out '%{http_code}' "http://$website/lemp.check")
rm -rf /home/$website/public_html/lemp.check

if [ ! "$checkurlstt" = "200" ] && [ ! "$checkurlsttSSL" = "200" ]; then
clear
echo "========================================================================="
echo "Ban chua tro $website toi $serverip !"
echo "-------------------------------------------------------------------------"
echo "LEMP khong the chay chuc nang nay."
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
fi

if [ "$checkurlstt" = "200" ]; then
clear
echo "========================================================================="
echo "$websiteTO khong su dung SSL by Let's Encrypt"
echo "-------------------------------------------------------------------------"
echo "LEMP khong the chay chuc nang nay."
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
fi

if [ "$(grep "/etc/nginx/auth-acme/$website/$website.crt" /etc/nginx/conf.d/$website.conf)" = "" ] && [ "$checkurlsttSSL" == "200" ]; then
clear
echo "========================================================================="
echo "$websiteTO su dung SSL nhung khong phai SSL cua Let's Encrypt."
echo "-------------------------------------------------------------------------"
echo "LEMP khong the thuc hien chuc nang nay."
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
exit
fi




if [ ! -f /etc/lemp/Backup.Vhost.SSL/$website/$website.conf ] && [ ! -f /etc/lemp/Backup.Vhost.SSL/$website/$website.conf_HTTPS ]; then
echo "-------------------------------------------------------------------------"
echo "Khong tim thay file backup Vhost cua $website."
echo "========================================================================="
  read -r -p "Ban van muon remove SSL cho $websiteTO [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    
rm -rf /etc/lemp/.tmp/$website.conf_HTTPS
yes | cp -rf  /etc/nginx/conf.d/$website.conf /etc/lemp/.tmp/$website.conf_HTTPS
yes | cp -rf  /etc/nginx/conf.d/$website.conf /etc/lemp/.tmp/$website.conf_HTTPS_run

rm -rf /etc/lemp/.tmp/servername
grep "server_name\ $website" /etc/lemp/.tmp/$website.conf_HTTPS_run > /etc/lemp/.tmp/servername
servername=$(cat /etc/lemp/.tmp/servername)

sed -i "1,/${servername}/d" /etc/lemp/.tmp/$website.conf_HTTPS_run  
# Tao vhost website
rm -rf /etc/lemp/.tmp/$website.conf.txt

cat > "/etc/lemp/.tmp/$website.conf.txt" <<END
server {
	    server_name www.$website;
	    rewrite ^(.*) http://$website$1 permanent;
    	}
server {
	    listen   80;
    	access_log off;
    	# access_log   /home/$website/logs/access_log;
    	error_log off;
    	# error_log /home/$website/logs/error.log;
    	add_header X-Frame-Options SAMEORIGIN;
		add_header X-Content-Type-Options nosniff;
		add_header X-XSS-Protection "1; mode=block";
		root /home/$website/public_html;
include /etc/nginx/conf/ddos2.conf;
	index index.php index.html index.htm;
$servername
END

cd /etc/lemp/.tmp/
rm -rf $website.conf
cat $website.conf.txt $website.conf_HTTPS_run > $website.conf
rm -rf /etc/lemp/.tmp/$website.conf_HTTPS_run
rm -rf /etc/lemp/.tmp/$website.conf.txt
cd    
yes | cp -rf /etc/lemp/.tmp/$website.conf /etc/nginx/conf.d/$website.conf
nginx -t

systemctl restart nginx

rm -rf /home/$website/public_html/lemp.check
echo "Check $website Non SSL" > /home/$website/public_html/lemp.check
checkurlstt=$(curl -o /dev/null --silent --head --write-out '%{http_code}' "http://$website/lemp.check")
rm -rf /home/$website/public_html/lemp.check

if [ "$checkurlstt" = "200" ] ; then
rm -rf /etc/lemp/.tmp/$website.conf_HTTPS
rm -rf /root/.acme.sh/${website}*
rm -rf /etc/nginx/auth-acme/$website
rm -rf /etc/lemp/Backup.Vhost.SSL/$website
clear
echo "========================================================================="
echo "Remove SSL cho $websiteTO thanh cong."
echo "-------------------------------------------------------------------------"
echo "Clear cache trinh duyet va check $website !"
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
else
yes | cp -rf  /etc/lemp/.tmp/$website.conf_HTTPS /etc/nginx/conf.d/$website.conf
rm -rf /etc/lemp/.tmp/$website.conf_HTTPS
rm -rf /etc/lemp/.tmp/$website.conf
systemctl restart nginx
clear
echo "========================================================================="
echo "Co loi xay ra trong qua trinh remove SSL cho $websiteTO."
echo "-------------------------------------------------------------------------"
echo "LEMP khong the chay chuc nang nay."
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
exit
fi

;;
    *)
clear 
echo "========================================================================= "
echo "Cancel !"
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
        ;;
esac
fi


echo "========================================================================="
  read -r -p "Ban muon remove SSL cho $websiteTO [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
echo "-------------------------------------------------------------------------"
echo "LEMP will retore backup Vhost NON_SSL (HTTP) of $websiteTO."
echo "-------------------------------------------------------------------------"
echo "Please wait ..."; sleep 2
rm -rf /etc/lemp/.tmp/$website.conf_HTTPS
yes | cp -rf  /etc/nginx/conf.d/$website.conf /etc/lemp/.tmp/$website.conf_HTTPS
yes | cp -rf /etc/lemp/Backup.Vhost.SSL/$website/$website.conf /etc/nginx/conf.d/$website.conf

systemctl restart nginx
rm -rf /home/$website/public_html/lemp.check
echo "Check $website SSL" > /home/$website/public_html/lemp.check
checkurlstt=$(curl -o /dev/null --silent --head --write-out '%{http_code}' "http://$website/lemp.check")
rm -rf /home/$website/public_html/lemp.check

if [ "$checkurlstt" = "200" ] ; then
rm -rf /etc/lemp/.tmp/$website.conf_HTTPS
rm -rf /root/.acme.sh/${website}*
rm -rf /etc/nginx/auth-acme/$website
rm -rf /etc/lemp/Backup.Vhost.SSL/$website
clear
echo "========================================================================="
echo "Remove SSL cho $websiteTO thanh cong."
echo "-------------------------------------------------------------------------"
echo "Clear cache trinh duyet va check $website !"
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
else
yes | cp -rf  /etc/lemp/.tmp/$website.conf_HTTPS /etc/nginx/conf.d/$website.conf
rm -rf /etc/lemp/.tmp/$website.conf_HTTPS
systemctl restart nginx
clear
echo "========================================================================="
echo "Co loi xay ra trong qua trinh remove SSL cho $websiteTO."
echo "-------------------------------------------------------------------------"
echo "LEMP khong the chay chuc nang nay."
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
fi
;;
    *)
clear 
echo "========================================================================= "
echo "Cancel !"
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
        ;;
esac