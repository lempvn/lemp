#!/bin/bash 

. /home/lemp.conf
echo "========================================================================="
echo "Su dung chuc nang nay de them website vao server"
echo "-------------------------------------------------------------------------"
echo -n "Nhap ten domain [ENTER]: " 
read website
website=`echo $website | tr '[A-Z]' '[a-z]'`
if [ "$website" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai!"
/etc/lemp/menu/lemp-them-website-menu.sh
exit
fi

kiemtradomain3="^([[:alnum:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)+[[:alpha:]]{2,12}$";
if [[ ! "$website" =~ $kiemtradomain3 ]]; then
	website=`echo $website | tr '[A-Z]' '[a-z]'`
clear
echo "========================================================================="
echo "$website co le khong phai la domain !!"
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai  !"
/etc/lemp/menu/lemp-them-website-menu.sh
exit
fi

if [ -f /etc/nginx/conf.d/$website.conf ]; then
clear
echo "========================================================================="
echo "Phat hien $website da ton tai tren he thong!"
/etc/lemp/menu/lemp-them-website-menu.sh
exit
fi

# Chuyen ten website thanh user name quan ly website 
convert_to_username() {
    # Thay the dau cham bang dau gach duoi de tao ten nguoi dung hop le
    webuser=$(echo "$website" | sed 's/\./_/g')

    # Tra ve webuser da chuyen doi
    echo "$webuser"
}

# Goi ham va luu gia tri tra ve vao bien moi
webuser=$(convert_to_username "$website")
echo "Original website: $website"
echo "Converted webuser: $webuser"


    mkdir -p "/home/$website/public_html"
    \cp -uf /etc/lemp/menu/robots.txt "/home/$website/public_html/"

sudo useradd -M -d "/home/$website/public_html" "$webuser"
sudo usermod -s /bin/bash "$webuser"

find "/home/$website/public_html/" -type d -exec chmod g+s {} \;
    mkdir -p "/home/$website/logs"

add_index_html(){

cat > "/home/$website/public_html/index.html" <<END
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
	<head>
		<title>Them $website vao server bang lemp thanh cong !</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<style type="text/css">
			/*<![CDATA[*/
			body {
				background-color: #fff;
				color: #000;
				font-size: 0.9em;
				font-family: sans-serif,helvetica;
				margin: 0;
				padding: 0;
			}
		 h1 {
				text-align: center;
				margin: 1;
				padding: 1em 2em 1em;
				background-color: yellow;
				color: red;
				font-weight: normal;
				font-size: 2em;
				border-bottom: 5px solid #000;
			}
			h1 strong {
				font-weight: bold;
			}
			/*]]>*/
		</style>
	</head>
	<body>
		<h1><strong>Them $website vao server bang <a href="https://lemp.vn/" title="Cai dat lemp, huong dan cai dat lemp tren VPS server" > lemp</a> thanh cong !</strong></h1>
			</body>
</html>
END

}
#add_index_html

#
add_index_php(){

cat > "/home/$website/public_html/index.php" <<END
<?php
echo 'Webcome to LEMP Hosting!<br>';
echo phpversion() . '<br>';
echo __FILE__ . ':' . __LINE__;
?>
END

}
add_index_php

chown -R ${webuser}:${webuser} "/home/$website/public_html/"


cat > "/etc/nginx/conf.d/$website.conf" <<END
server {
    listen 80;
    server_name www.${website};
    
    # Redirect all www traffic to non-www
    return 301 http://${website}\$request_uri;
}
server {
	    listen   80;
		server_name $website;

    	access_log   /home/$website/logs/access_log;
    	error_log /home/$website/logs/error.log error;	
    	add_header X-Frame-Options SAMEORIGIN;
		add_header X-Content-Type-Options nosniff;
		add_header X-XSS-Protection "1; mode=block";
		root /home/$website/public_html;
		include /etc/nginx/conf/ddos2.conf;
		index index.php index.html index.htm;


#///////////////////////////////////////////////////////////////
# Ban chi co the chon 1 trong 4 rule AAA, BBB, CCC, DDD hoac EEE
# Ban nen comment cac rule khong su dung thay vi xoa chung vi neu ban su dung wordpress blog 
# Cac dong nay can thiet cho cac chuc nang trong Wordpress Blog Tools cua LEMP
# Thuat ngu:
# Comment - Them dau # vao truoc
# Uncomment - Bo dau # o truoc cau.
#///////////////////////////////////////////////////////////////


#Chay tat ca cac website (Wordpress, Xenforo, Joomla, Phpbb .... ). neu ban su dung rule cua ban,comment dong duoi (them dau # vao truoc) (AAA)
include /etc/nginx/conf/all.conf;

#Neu ban su dung rule cua minh, comment rule o tren. Sau do uncoment (bo dau # ba dong duoi) sau do them rule vao giua. (BBB)
#location / {
#Uncomment 3 dong nay, sau do cho rule cua ban vao day!
#}

# Rule cho wordpress + Plugin wp super cache. Neu ban su dung wordpress va wp super cache, uncomment dong duoi va comment dong AAA phia tren. (CCC)
#include /etc/nginx/conf/supercache.conf; 

# Rule cho wordpress + Plugin W3 Total Cache. Neu ban su dung wordpress va W3 Total, uncomment dong duoi va comment dong AAA phia tren. (DDD)
#include /etc/nginx/conf/w3total.conf;

# Rule cho wordpress + Plugin wp rocket Cache. Neu ban su dung wordpress va wp rocket, uncomment dong duoi va comment hoac xoa dong AAA phia tren. (EEE)
#include /etc/nginx/conf/wprocket.conf; 

# Confif Cache Static Files
include /etc/nginx/conf/staticfiles.conf;  

#Tang bao mat security, chong sql injection  ....(uncoment neu ban muon su dung). Boi vi mot so code website khong su dung duoc voi rule nay, nen mac dinh lemp de tat.
#Khong duoc xoa dong duoi, neu xoa LEMP se khong hoat dong !
#include /etc/nginx/conf/block.conf;

# Error Page
#error_page 403 /errorpage_html/403.html;
#error_page 404 /errorpage_html/404.html;
#error_page 405 /errorpage_html/405.html;
#error_page 502 /errorpage_html/502.html;
#error_page 503 /errorpage_html/503.html;
#error_page 504 /errorpage_html/504.html;
#location ^~ /errorpage_html/ {
#   internal;
#    root /home/$website;
#    access_log              off;
#}
    	location ~ \.php$ {
		fastcgi_split_path_info ^(.+\.php)(/.+)$;
        include /etc/nginx/fastcgi_params;
		fastcgi_pass unix:/var/run/${webuser}.sock;
        fastcgi_index index.php;
		fastcgi_connect_timeout 250;
		fastcgi_send_timeout 250;
		fastcgi_read_timeout 250;
		fastcgi_buffer_size 256k;
		fastcgi_buffers 4 256k;
		fastcgi_busy_buffers_size 256k;
		fastcgi_temp_file_write_size 256k;
		fastcgi_intercept_errors on;
        	fastcgi_param SCRIPT_FILENAME /home/$website/public_html\$fastcgi_script_name;
    	}

#include /etc/nginx/conf/phpstatus.conf;
include /etc/nginx/conf/drop.conf;

    }
END

# Lay phien ban php hien tai
PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")

cat > "/etc/php/${PHP_VERSION}/fpm/pool.d/${webuser}.conf" << END
[${webuser}]
listen = /var/run/${webuser}.sock
user = ${webuser}
group = ${webuser}

listen.owner = ${webuser}
listen.group = www-data
listen.mode = 0660

pm = dynamic
pm.max_children = 33
pm.start_servers = 3
; Defaul: pm.min_spare_servers + (pm.max_spare_servers - pm.min_spare_servers) / 2
pm.min_spare_servers = 2
pm.max_spare_servers = 6
pm.max_requests = 500
pm.status_path = /php_status
request_terminate_timeout = 100s
pm.process_idle_timeout = 10s;
request_slowlog_timeout = 4s
slowlog = /home/lemp.demo/logs/php-fpm-slow.log
rlimit_files = 131072
rlimit_core = unlimited
catch_workers_output = yes
env[HOSTNAME] = \\$HOSTNAME
env[PATH] = /usr/local/bin:/usr/bin:/bin
env[TMP] = /tmp
env[TMPDIR] = /tmp
env[TEMP] = /tmp
php_admin_value[error_log] = /home/lemp.demo/logs/php-fpm-error.log
php_admin_flag[log_errors] = on
php_value[session.save_handler] = files

END


if [ ! -d /etc/lemp/errorpage_html ]; then
	if [ -d /opt/vps_lemp/script/lemp/errorpage_html ]; then
		mkdir -p /etc/lemp/errorpage_html ; chmod 755 /etc/lemp/errorpage_html
		yes | cp -rf /opt/vps_lemp/script/lemp/errorpage_html/. /etc/lemp/errorpage_html/
	fi
fi

mkdir -p /home/$website/errorpage_html && cp -r /etc/lemp/errorpage_html/*.html /home/$website/errorpage_html
############################################################################
############################################################################
echo "-------------------------------------------------------------------------"
read -r -p "Ban co muon LEMP tao Database moi cho $website ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY])
    echo "-------------------------------------------------------------------------"
    echo "Please wait....";sleep 1 
   echo "$website" > /tmp/databasename.txt
#echo $website | sed "s/\./_/" | sed "s/\-/_/" | cut -c1-14  > /tmp/databasename.txt  
sed -i 's/\./_/g' /tmp/databasename.txt
sed -i 's/\-/_/g' /tmp/databasename.txt
random=`date |md5sum |cut -c '1-4'`
dataname=`cat /tmp/databasename.txt | cut -c1-11`_$random
username=`cat /tmp/databasename.txt | sed "s/\_//" | sed "s/\_//" | sed "s/\_//" | sed "s/\_//" | cut -c1-10`$random
#password=`date |md5sum |cut -c '14-29'`
password=$(< /dev/urandom tr -dc 'A-Za-z0-9' | head -c 24)

rm -rf /tmp/databasename.txt
cat > "/tmp/config.temp" <<END
CREATE DATABASE $dataname COLLATE utf8_general_ci;
END

mariadb -u root -p$mariadbpass < /tmp/config.temp
rm -f /tmp/config.temp

 cat > "/tmp/config.temp" <<END
CREATE USER '$username'@'localhost' IDENTIFIED BY '$password';
END

	mariadb -u root -p$mariadbpass < /tmp/config.temp
	rm -f /tmp/config.temp

    cat > "/tmp/config.temp" <<END
GRANT ALL PRIVILEGES ON $dataname . * TO '$username'@'localhost';
END
	mariadb -u root -p$mariadbpass < /tmp/config.temp
	rm -f /tmp/config.temp

    cat > "/tmp/config.temp" <<END
FLUSH PRIVILEGES;
END
	mariadb -u root -p$mariadbpass < /tmp/config.temp
	rm -f /tmp/config.temp

echo "=========================================================================" >> /home/DBinfo.txt
echo "Database: $dataname - Created on: $(date +%d/%m/%Y) when add $website to VPS" >> /home/DBinfo.txt
echo "=========================================================================" >> /home/DBinfo.txt
echo "Data name: $dataname" >> /home/DBinfo.txt
echo "Username: $username" >> /home/DBinfo.txt
echo "password: $password" >> /home/DBinfo.txt
echo "" >> /home/DBinfo.txt

systemctl restart nginx
systemctl restart php${PHP_VERSION}-fpm.service
clear

echo "========================================================================="
echo "$website them thanh cong vao server"
echo "-------------------------------------------------------------------------"
echo "Vhost File: /etc/nginx/conf.d/$website.conf"
echo "-------------------------------------------------------------------------"
echo "Upload code vao /home/$website/public_html"
echo "-------------------------------------------------------------------------"
echo "Database duoc tao tu dong cho $website :"
echo "-------------------------------------------------------------------------"
echo "Ten Database: $dataname"
echo "User name: $username" 
echo "Mat khau: $password"
echo "-------------------------------------------------------------------------"
echo "Thong tin database da duoc luu vao: /home/DBinfo.txt"
/etc/lemp/menu/lemp-them-website-menu.sh
        ;;
    *)

systemctl restart nginx
systemctl restart php${PHP_VERSION}-fpm.service
clear

echo "========================================================================="
echo "$website duoc them thanh cong vao server"
echo "-------------------------------------------------------------------------"
echo "Upload code to /home/$website/public_html"
echo "-------------------------------------------------------------------------"
echo "Vhost File: /etc/nginx/conf.d/$website.conf"
/etc/lemp/menu/lemp-them-website-menu.sh
        ;;
esac
