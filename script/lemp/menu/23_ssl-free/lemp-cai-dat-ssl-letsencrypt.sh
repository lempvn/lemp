#!/bin/bash
. /home/lemp.conf

# Rate limit on registrations per IP is currently 10 per 3 hours
# Rate limit on certificates per Domain is currently 5 per 7 days

if [ ! -d /etc/lemp/Backup.Vhost.SSL ]; then
mkdir -p /etc/lemp/Backup.Vhost.SSL
fi

if [ ! -d /etc/lemp/.tmp ]; then
mkdir -p /etc/lemp/.tmp
fi

if [ ! -f /root/.acme.sh/acme.sh ]; then
clear
echo "========================================================================="
echo "Cai dat tien ich Acme.Sh "
echo "-------------------------------------------------------------------------"
echo "Please wait ..."; sleep 3
wget -O -  https://get.acme.sh | sh
sleep 3
clear
echo "========================================================================="
echo "Cai dat acme.sh hoan thanh"
echo "-------------------------------------------------------------------------"
echo "Bay gio ban co the su dung chuc nang cai dat SSL cho website cua minh."
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
fi

echo "========================================================================="
echo "Su dung chuc nang nay de cai dat SSL (Let's Encrypt) cho website."
echo "-------------------------------------------------------------------------"
echo "Xem huong dan tai: https://lemp"
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
if [ -f /root/.acme.sh/${website}_ecc/$website.conf ]; then

echo "Check $website when Setup SSL" > /home/$website/public_html/lemp.check
checkurlsttSSL=$(curl -o /dev/null --silent --head --write-out '%{http_code}' "https://$website/lemp.check")
checkurlstt=$(curl -o /dev/null --silent --head --write-out '%{http_code}' "http://$website/lemp.check")
rm -rf /home/$website/public_html/lemp.check
if [[  "$checkurlsttSSL" == "200" ]]; then
clear
echo "========================================================================="
echo "Ban da cai dat thanh cong SSL cho $website."
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
exit
fi
if [[ "$checkurlstt" == "200" ]]; then

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
fi

################

rm -rf /etc/lemp/.tmp/servername
grep "server_name\ $website" /etc/nginx/conf.d/$website.conf > /etc/lemp/.tmp/servername
servername=$(cat /etc/lemp/.tmp/servername)
if [ ! -n /etc/lemp/.tmp/servername ]; then
clear
echo "========================================================================="
echo "Ban da thay doi cau hinh file Vhost khong dung voi config lemp yeu cau"
echo "-------------------------------------------------------------------------"
echo "LEMP khong the chay chuc nang nay."
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
exit
fi

if [ "`grep "block.conf;" /etc/nginx/conf.d/$website.conf`" = "" ]; then
clear
echo "========================================================================="
echo "Ban da thay doi cau hinh file Vhost khong dung voi config lemp yeu cau"
echo "-------------------------------------------------------------------------"
echo "LEMP khong the chay chuc nang nay"
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
exit
fi

echo "========================================================================="
echo "Tim thay $website tren he thong."
echo "-------------------------------------------------------------------------"
echo "Neu domain BAT cloudflare hoac chua TRO ve IP server"
echo "-------------------------------------------------------------------------"
echo "LEMP se khong the thuc hien chuc nang nay."
echo "========================================================================="
echo "========================================================================="
echo ""
sleep 7
echo "Kiem tra DNS cua domain ..."; sleep 3
echo "Check $website when Setup SSL" > /home/$website/public_html/lemp.check
checkurlstt=$(curl -o /dev/null --silent --head --write-out '%{http_code}' "http://$website/lemp.check")
checkurlsttSSL=$(curl -o /dev/null --silent --head --write-out '%{http_code}' "https://$website/lemp.check")
rm -rf /home/$website/public_html/lemp.check
if [[  "$checkurlsttSSL" == "200" ]]; then
clear
echo "========================================================================="
echo "Ban dang su dung SSL cho $website."
echo "-------------------------------------------------------------------------"
echo "Hien tai lemp khong ho tro chuyen tu SSL thuong sang Let's Encrypt SSL."
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
exit
fi
if [[ ! "$checkurlstt" == "200" ]]; then
clear
echo "========================================================================="
echo "Ban phai tro $website toi $serverip truoc khi thuc hien chuc nang nay"
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
exit
fi


echo "$websiteTO da tro toi $serverip. => [ OK ]"
echo ""

echo "Kiem tra Domain co BAT cloudflare (Hide IP Address) hay khong ? ..."; sleep 3


rm -rf /etc/lemp/.tmp/cloudflare.status
curl -I -s $website > /etc/lemp/.tmp/cloudflare.status
status_cloudflare=`grep cloudflare-nginx /etc/lemp/.tmp/cloudflare.status`
rm -rf /etc/lemp/.tmp/cloudflare.status
if [ ! "$status_cloudflare" = "" ]; then
clear
echo "========================================================================="
echo "$website dang BAT CloudFlare"
echo "-------------------------------------------------------------------------"
echo "Ban phai tat CloudFlare truoc khi su dung chuc nang nay."
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
exit
fi
echo "$websiteTO khong BAT Cloudflare. => [ OK ]"
echo ""
echo "========================================================================="
echo "========================================================================="
  read -r -p "Ban muon cai dat SSL cho $websiteTO [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "-------------------------------------------------------------------------"
echo "LEMP bat dau cai dat Let's Encrypt ..."
sleep 3

if [ ! -d /home/$website/public_html/.well-known/acme-challenge ]; then
mkdir -p /home/$website/public_html/.well-known
mkdir -p /home/$website/public_html/.well-known/acme-challenge
fi

rm -rf /etc/lemp/.tmp/config.ssl.$website.txt
cat > "/etc/lemp/.tmp/config.ssl.$website.txt" <<END

# Config for Free SSL (LetEncrypt) - Do not Delete !
location ~ /.well-known {
        allow all;
        root /home/$website/public_html;
    }
END

cd /etc/lemp/.tmp
if [ "`grep "location\ ~\ /.well-known\ {" /etc/nginx/conf.d/$website.conf`" == "" ]; then
sed -i "/block.conf;/r config.ssl.${website}.txt" /etc/nginx/conf.d/$website.conf
fi
cd

systemctl restart nginx

echo "Check $website when Setup SSL" > /home/$website/public_html/.well-known/acme-challenge/lemp.check
checkurlstt=$(curl -o /dev/null --silent --head --write-out '%{http_code}' "http://$website/.well-known/acme-challenge/lemp.check")
rm -rf /home/$website/public_html/.well-known/acme-challenge/lemp.check
if [[ ! "$checkurlstt" == "200" ]]; then
clear
echo "========================================================================="
echo "Qua trinh cai dat SSL cho $website gap loi."
echo "-------------------------------------------------------------------------"
echo "LEMP khong the thuc hien chuc nang nay."
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
exit
fi
mkdir -p /etc/nginx/auth-acme
mkdir -p /etc/nginx/auth-acme/$website
/root/.acme.sh/acme.sh --issue -d $website -w /home/$website/public_html --accountemail lemp@gmail.com
#/root/.acme.sh/acme.sh --issue -d $website -w /home/$website/public_html
/root/.acme.sh/acme.sh --installcert -d $website --keypath  /etc/nginx/auth-acme/$website/$website.key --capath  /etc/nginx/auth-acme/$website/$website.ca --fullchainpath  /etc/nginx/auth-acme/$website/$website.crt --reloadcmd "systemctl restart nginx"
sleep 5
if [ ! -s /etc/nginx/auth-acme/$website/$website.crt ]; then
rm -rf /etc/nginx/auth-acme/$website
rm -rf /root/.acme.sh/${website}_ecc
clear
echo "========================================================================="
echo "Qua trinh cai dat SSL cho $website gap loi."
echo "-------------------------------------------------------------------------"
echo "LEMP khong the cai dat SSL Let's Encrypt cho domain nay."
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
exit
fi

rm -rf /etc/lemp/.tmp/$website.conf.txt
cp -r /etc/nginx/conf.d/$website.conf /etc/lemp/.tmp/$website.conf.txt

# replace from 1 to server_name
sed -i "1,/${servername}/d" /etc/lemp/.tmp/$website.conf.txt
# Tao vhost ssl
rm -rf /etc/lemp/.tmp/SSL-$website.conf.txt

cat > "/etc/lemp/.tmp/SSL-$website.conf.txt" <<END
server {
listen 80;
server_name $website www.$website;
rewrite ^(.*) https://$website\$1 permanent;
}
server {
listen 443 ssl;
http2 on;
ssl_certificate /etc/nginx/auth-acme/$website/$website.crt;
ssl_certificate_key /etc/nginx/auth-acme/$website/$website.key;
ssl_session_cache shared:SSL:10m;
ssl_session_timeout 10m;
ssl_prefer_server_ciphers on;
include /etc/nginx/conf/ssl-protocol-cipher.conf;
ssl_stapling on;
ssl_stapling_verify on;
resolver 8.8.8.8 8.8.4.4 valid=300s;
resolver_timeout 30s;
ssl_trusted_certificate /etc/nginx/auth-acme/$website/$website.ca;
ssl_buffer_size 1400;
ssl_session_tickets on;
add_header Strict-Transport-Security max-age=31536000;
$servername
END

cd /etc/lemp/.tmp/
cat SSL-$website.conf.txt $website.conf.txt > $website.conf_HTTPS
rm -rf /etc/lemp/.tmp/SSL-$website.conf.txt
rm -rf /etc/lemp/.tmp/$website.conf.txt
cd
if [ ! -d /etc/lemp/Backup.Vhost.SSL ]; then
mkdir -p /etc/lemp/Backup.Vhost.SSL
fi
mkdir -p /etc/lemp/Backup.Vhost.SSL/$website
#Backup Vhost.Conf
yes | cp -rf  /etc/nginx/conf.d/$website.conf /etc/lemp/Backup.Vhost.SSL/$website/$website.conf
yes | cp -rf  /etc/lemp/.tmp/$website.conf_HTTPS /etc/lemp/Backup.Vhost.SSL/$website/$website.conf_HTTPS

yes | cp -rf /etc/nginx/conf.d/$website.conf /home/$website/$website.conf_HTTP
yes | cp -rf  /etc/lemp/.tmp/$website.conf_HTTPS /home/$website/$website.conf_HTTPS
yes | cp -rf  /etc/lemp/.tmp/$website.conf_HTTPS /etc/nginx/conf.d/$website.conf
rm -rf /etc/lemp/.tmp/$website.conf_HTTPS
rm -rf /home/$website/public_html/lemp.check2
echo "Check SSL Setup" > /home/$website/public_html/lemp.check2
systemctl restart nginx

checkurlstt=$(curl -o /dev/null --silent --head --write-out '%{http_code}' "https://$website/lemp.check2")
rm -rf /home/$website/public_html/lemp.check2
if [[ ! "$checkurlstt" == "200" ]]; then
yes | cp -rf  /home/$website/$website.conf_HTTP /etc/nginx/conf.d/$website.conf

systemctl restart nginx

clear
echo "========================================================================="
echo "Qua trinh cai dat tu dong Let's Encrypt cho $website that bai."
echo "-------------------------------------------------------------------------"
echo "Ban phai tu edit Vhost cua $website theo thong tin duoi:"
echo "-------------------------------------------------------------------------"
echo "File Vhost: /etc/nginx/conf.d/$website.conf"
echo "-------------------------------------------------------------------------"
echo "Backup Vhost: /home/$website/$website.conf_HTTP"
echo "-------------------------------------------------------------------------"
echo "Backup SSL Vhost: /home/$website/$website.conf_HTTPS"
/etc/lemp/menu/23_ssl-free/lemp-letsencrypt-menu.sh
else
nextgiahan=`cat /root/.acme.sh/${website}_ecc/$website.conf | grep NextRenewTimeStr | cut -d \" -f 2 `
curTime=$(date +%s)
thoigiangiahangiay=`cat /root/.acme.sh/${website}_ecc/$website.conf | grep Le_NextRenewTime= | cut -d \" -f 2`
hieuthoigianconlai=$(calc $thoigiangiahangiay-$curTime)
thoigiannengiahanlai=$(calc $hieuthoigianconlai/60/60/24)
thoigianconlai=$(calc $thoigiannengiahanlai+10)
clear
echo "========================================================================="
echo "Cai dat tu dong Let's Encrypt cho $website thanh cong."
echo "-------------------------------------------------------------------------"
echo "Truy cap $website tren trinh duyet de check."
echo "-------------------------------------------------------------------------"
if [ -f /home/$website/public_html/wp-config.php ]; then
echo "$websiteTO su dung code Wordpress. "
echo "-------------------------------------------------------------------------"
echo "Ban nen cai dat plugin [ Really Simple SSL ] cho website cua minh."
echo "-------------------------------------------------------------------------"
fi 
echo "Backup Vhost: /home/$website/$website.conf_HTTP"
echo "-------------------------------------------------------------------------"
echo "Backup SSL Vhost: /home/$website/$website.conf_HTTPS"
if [ -f /etc/lemp/Renew.SSL.Letencrypt ] && [ -f /etc/cron.d/lemp.autorenew.ssl.cron ]; then
echo "-------------------------------------------------------------------------"
echo "LEMP se tu dong gia han chung chi sau: $thoigiannengiahanlai ngay."
else
echo "-------------------------------------------------------------------------"
echo "BAN CHUA BAT TINH NANG TU DONG GIA HAN SSL."
fi
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
