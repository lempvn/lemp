#!/bin/bash
. /home/lemp.conf
echo "========================================================================= "
echo -n "Nhap ten website ban muon cai dat SSL [ENTER]: " 
read domainssl
if [ "$domainssl" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai !"
/etc/lemp/menu/lemp-tao-ssl-menu.sh
exit
fi
kiemtradomain3="^([[:alnum:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)+[[:alpha:]]{2,12}$";
if [[ ! "$domainssl" =~ $kiemtradomain3 ]]; then
	domainssl=`echo $domainssl | tr '[A-Z]' '[a-z]'`
clear
echo "========================================================================="
echo "$domainssl co le khong phai la domain !!"
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai  !"
/etc/lemp/menu/lemp-tao-ssl-menu.sh
exit
fi 

if [ ! -f /etc/nginx/conf.d/$domainssl.conf ]; then
clear
echo "========================================================================="
echo "$domainssl khong ton tai tren he thong!"
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai "
/etc/lemp/menu/lemp-tao-ssl-menu.sh
exit
fi

if [ -f /etc/nginx/ssl/$domainssl/$domainssl.csr ]; then
clear
echo "========================================================================= "
echo "$domainssl.key da duoc tao tren VPS."
echo "-------------------------------------------------------------------------"
echo "Ban co the download CSR tai: http://$serverip:$priport/$domainssl.csr"
echo "-------------------------------------------------------------------------"
echo "Neu ban muon tao lai, hay xoa $domainssl trong /etc/nginx/ssl/ "
echo "-------------------------------------------------------------------------"
echo "Va dung chuc nang nay lan nua!"
/etc/lemp/menu/lemp-tao-ssl-menu.sh
exit
fi

mkdir -p /etc/nginx/ssl/$domainssl
cd /etc/nginx/ssl/$domainssl
sleep 3
clear
echo "========================================================================= "
echo "Step I: Tao $domainssl.key"
echo "========================================================================= "
echo "Ban dien thong tin tuong tu nhu duoi day"
echo "========================================================================= "
sleep 3
echo "Country Name :VN"
echo "State or Province Name :Ha Noi"
echo "Locality Name :HN"
echo "Organization Name (eg, company) :SoftwareDev, LLC"
echo "Organizational Unit Name :Web Services"
echo "Common Name : $domainssl"                 
echo "Email Address :your-email@domain.com"
echo "A challenge password :  (Enter)"
echo "An optional company name :  (Enter)"
echo "========================================================================= "
read -p "Nhan [Enter] de tiep tuc ..."
openssl req -nodes -newkey rsa:2048 -keyout $domainssl.key -out $domainssl.csr
\cp -uf /etc/nginx/ssl/$domainssl/$domainssl.csr /home/$mainsite/private_html/
sudo cp $domainssl.key $domainssl.key.org
sudo openssl rsa -in $domainssl.key.org -out $domainssl.key
clear
echo "========================================================================= "
echo "========================================================================= "
echo "Step II: Sign SSL Certificate"
echo "========================================================================= "
echo "========================================================================= "
sudo openssl x509 -req -days 365 -in $domainssl.csr -signkey $domainssl.key -out $domainssl.crt
sleep 3
cat > "/home/$mainsite/private_html/$domainssl.conf.txt" <<END
======================================================
Doan nay se thay cho doan phia duoi trong file vhost /etc/nginx/conf.d/$domainssl.conf
======================================================

server {
    listen 80;
    server_name $domainssl www.$domainssl;
    rewrite ^(.*) https://$domainssl\$1 permanent;
}
server {
    listen 443 ssl http2; # Su dung dong config nay cho NGINX tu phien ban 1.9.5
    #listen 443 ssl spdy; # Su dung dong config nay cho NGINX truoc phien ban 1.9.5
    ssl_certificate /etc/nginx/ssl/$domainssl/$domainssl.crt;
    ssl_certificate_key /etc/nginx/ssl/$domainssl/$domainssl.key; 
 ssl_session_cache shared:SSL:10m;
 ssl_session_timeout 10m;
 ssl_prefer_server_ciphers on;
 ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
  ssl_ciphers ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA:!CAMELLIA:!DES-CBC3-SHA;
   #ssl_stapling on;
 #resolver 8.8.4.4 8.8.8.8 valid=300s;
 #resolver_timeout 10s;
  ssl_trusted_certificate /etc/nginx/ssl/$domainssl/$domainssl.crt;
      ssl_buffer_size 1400;
  ssl_session_tickets on;
add_header Strict-Transport-Security max-age=31536000;
    	error_log off;
    	# error_log /home/$domainssl/logs/error.log;
    	root /home/$domainssl/public_html;
include /etc/nginx/conf/ddos2.conf;
	index index.php index.html index.htm;
        server_name $domainssl;

=======================================================


-------------------------------------------------------------------
Doan nay can thay the:
-------------------------------------------------------------------


=======================================================

server {
	    server_name www.$domainssl;
	    rewrite ^(.*) http://$domainssl\$1 permanent;
    	}
server {
	    listen   80;

    	access_log off;
    	error_log off;
    	# error_log /home/$domainssl/logs/error.log;
    	root /home/$domainssl/public_html;
include /etc/nginx/conf/ddos2.conf;
 	index index.php index.html index.htm;
    	server_name $domainssl;

=========================================================
 

=========================================================
Doan duoi day hoac tuong tu nhu duoi se giu nguyen:
=========================================================

#///////////////////////////////////////////////////////
#///////////////////////////////////////////////////////
#Chay ta ca cac website. neu ban su dung rule cua ban, xoa dong duoi hoac comment (them dau # vao truoc) (AAA)
include /etc/nginx/conf/all.conf;

#Neu ban su dung rule cua minh, comment hoac xoa rule o tren. Sau do uncoment (bo dau # ba dong duoi) sau do them rule vao giua.
#location / {
#Uncomment 3 dong nay, sau do cho rule cua ban vao day!
#}

# Rule cho wordpress + Plugin wp super cache. Neu ban su dung wordpress, uncomment dong duoi va comment hoac xoa dong AAA phia tren.
#include /etc/nginx/conf/supercache.conf;

# Rule cho wordpress + Plugin W3 Total Cache. Neu ban su dung wordpress va W3 Total, uncomment dong duoi va comment hoac xoa dong AAA phia tren. (DDD)
#include /etc/nginx/conf/w3total.conf;

# Rule cho wordpress + Plugin wp rocket Cache. Neu ban su dung wordpress va wp rocket, uncomment dong duoi va comment hoac xoa dong AAA phia tren. (EEE)
#include /etc/nginx/conf/wprocket.conf;  

#Khong duoc xoa dong duoi neu khong huc nang google pagespeed cua wordpress se khong hoat dong!
#include /etc/nginx/ngx_pagespeed.conf;

#Tang bao mat security, chong sql injection  ....(uncoment neu ban muon su dung). Boi vi mot so code website khong su dung duoc voi rule nay, nen mac dinh HZserver de tat.
#include /etc/nginx/conf/block.conf;

    	location ~ \.php$ {
		fastcgi_split_path_info ^(.+\.php)(/.+)$;
        	include /etc/nginx/fastcgi_params;
        	fastcgi_pass 127.0.0.1:9000;
        	fastcgi_index index.php;
		fastcgi_connect_timeout 60;
		fastcgi_send_timeout 180;
		fastcgi_read_timeout 180;
		fastcgi_buffer_size 256k;
		fastcgi_buffers 4 256k;
		fastcgi_busy_buffers_size 256k;
		fastcgi_temp_file_write_size 256k;
		fastcgi_intercept_errors on;
        	fastcgi_param SCRIPT_FILENAME /home/$domainssl/public_html\$fastcgi_script_name;
    	}
include /etc/nginx/conf/staticfiles.conf;
#include /etc/nginx/conf/phpstatus.conf;
include /etc/nginx/conf/drop.conf;
#include /etc/nginx/conf/errorpage.conf;
    }
END
clear
echo "========================================================================= "
echo "SSL da duoc cai dat 365 ngay cho $domainssl tren VPS"
echo "-------------------------------------------------------------------------"
echo "Ban can edit /etc/nginx/conf.d/$domainssl.conf de hoan thanh cai dat SSL"
echo "-------------------------------------------------------------------------"
echo "Link download $domainssl.conf mau: "
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/$domainssl.conf.txt"
echo "-------------------------------------------------------------------------"
echo "Su dung $domainssl.csr de dang ky SSL cua ben thu 3"
echo "-------------------------------------------------------------------------"
echo "Link download $domainssl.csr:"
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/$domainssl.csr"
echo "-------------------------------------------------------------------------"
echo "Xem huong dan tren LEMP.VN"
echo "========================================================================= "
read -p "Press [Enter] de quay tro lai LEMP ..."
clear
lemp
exit
fi


