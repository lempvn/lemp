#!/bin/bash 

. /home/lemp.conf

PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")

echo "========================================================================="
echo "Them Domain + Tu dong cai dat Wordpress + Config Vhost cho WP Super Cache"
echo "-------------------------------------------------------------------------"
echo "Sau khi them Domain vao VPS, Website cua ban san sang hoat dong ngay"
echo "-------------------------------------------------------------------------"
echo "Ban khong can cai dat thu cong Wordpress nua."
echo "-------------------------------------------------------------------------"
echo "Cac Plugins duoc tu dong cai dat trong qua trinh cai Wordpress: "
echo "-------------------------------------------------------------------------"
echo "WP Super Cache, WP Limit Attemps, No Category Base"
echo "========================================================================="
echo -n "Nhap domain ban muon them [ENTER]: " 
read website
website=`echo $website | tr '[A-Z]' '[a-z]'`
if [ "$website" = "" ]; then
clear
echo "========================================================================="
echo "Ban phai nhap ten domain"
/etc/lemp/menu/lemp-them-website-menu.sh
exit
fi
kiemtradomain3="^([[:alnum:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)+[[:alpha:]]{2,14}$";
if [[ ! "$website" =~ $kiemtradomain3 ]]; then
	website=`echo $website | tr '[A-Z]' '[a-z]'`
clear
echo "========================================================================="
echo "$website khong phai la domain!"
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai !"
/etc/lemp/menu/lemp-them-website-menu.sh
exit
fi
if [ -f /etc/nginx/conf.d/$website.conf ]; then
clear
echo "========================================================================="
echo "Phat hien $website da ton tai tren he thong!"
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai !"
/etc/lemp/menu/lemp-them-website-menu.sh
exit
fi

echo "-------------------------------------------------------------------------"
echo -n "Nhap tai khoan wordpress admin [ENTER]: " 
read adminwp
if [ "$adminwp" = "" ]; then
echo "========================================================================="
echo "Ban phai nhap tai khoan wordpress admin."
/etc/lemp/menu/lemp-them-website-menu.sh
exit
fi
checkuseradmin="^[a-zA-Z0-9_][-a-zA-Z0-9_]{0,61}[a-zA-Z0-9_]$";
if [[ ! "$adminwp" =~ $checkuseradmin ]]; then
clear
echo "========================================================================="
echo "Ban chi duoc su dung chu cai va so cho user admin"
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai  !"
/etc/lemp/menu/lemp-them-website-menu.sh
exit
fi 
if [[ ! ${#adminwp} -ge 5 ]]; then
clear
echo "========================================================================="
echo "User admin toi thieu phai co 5 ki tu "
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai !"
/etc/lemp/menu/lemp-them-website-menu.sh
exit
fi 
echo "-------------------------------------------------------------------------"
echo "Mat khau cho $adminwp toi thieu phai co 8 ki tu"
echo "-------------------------------------------------------------------------"
echo -n "Nhap mat khau cho user $adminwp [ENTER]: " 
read passwp
if [[ ! ${#passwp} -ge 8 ]]; then
clear
echo "========================================================================="
echo "Mat khau cho $adminwp toi thieu phai co 8 ki tu "
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai !"
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


#/etc/lemp/menu/lemp-enable-tat-ca-cac-ham-php-php.ini
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


#////////////////////////////////////////////////////////////////
# Ban chi co the chon 1 trong 4 rule AAA, BBB, CCC, DDD hoac EEE
# Ban nen comment cac rule khong su dung thay vi xoa chung vi neu ban su dung wordpress blog 
# Cac dong nay can thiet cho cac chuc nang trong Wordpress Blog Tools cua LEMP
# Thuat ngu:
# Comment - Them dau # vao truoc
# Uncomment - Bo dau # o truoc cau.
#////////////////////////////////////////////////////////////////


#Chay tat ca cac website (Wordpress, Xenforo, Joomla, Phpbb .... ). Neu ban su dung rule cua ban,comment dong duoi (them dau # vao truoc) (AAA)
#include /etc/nginx/conf/all.conf;

#Neu ban su dung rule cua minh, comment rule o tren. Sau do uncoment (bo dau # ba dong duoi) sau do them rule vao giua. (BBB)
#location / {
#Uncomment 3 lines and set your rules here!
#}

# Rule cho wordpress + Plugin wp super cache. Neu ban su dung wordpress va wp super cache, uncomment dong duoi va comment dong AAA phia tren (CCC)
include /etc/nginx/conf/supercache.conf;  

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

#######################################################################
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


#######################################################################

mkdir -p /home/$website/errorpage_html && cp -r /etc/lemp/errorpage_html/*.html /home/$website/errorpage_html
echo "$website" > /tmp/databasename.txt
#echo $website | sed "s/\./_/" | sed "s/\-/_/" | cut -c1-14  > /tmp/databasename.txt  
sed -i 's/\./_/g' /tmp/databasename.txt
sed -i 's/\-/_/g' /tmp/databasename.txt
random=`date |md5sum |cut -c '1-4'`
randomwp=`date |md5sum |cut -c '1-7'`
dataname=`cat /tmp/databasename.txt | cut -c1-11`_$random
username=`cat /tmp/databasename.txt | sed "s/\_//" | sed "s/\_//" | sed "s/\_//" | sed "s/\_//" | cut -c1-10`$random
#password=`date |md5sum |cut -c '14-29'`
password=$(< /dev/urandom tr -dc 'A-Za-z0-9' | head -c 24)
passworduseradmin=`date |md5sum |cut -c '1-15'`
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
    mkdir -p /home/$website/public_html
    mkdir -p /home/$website/logs
    cd /home/$website/public_html
    echo "========================================================================="
    echo "Chuan bi download va cai dat wordpress ..."
    sleep 3
    wget https://wordpress.org/latest.zip
    unzip -q latest.zip
    mv wordpress/* ./
    rm -rf wordpress
    rm -rf latest.zip

sudo useradd -M -d "/home/$website/public_html" "$webuser"
sudo usermod -s /bin/bash "$webuser"


chown -R ${webuser}:${webuser} "/home/$website/public_html/"
find /home/$website/public_html/ -type d -exec chmod g+s {} \;
\cp -uf /etc/lemp/menu/robots.txt /home/$website/public_html/
#echo "define('FS_METHOD','direct');" >> /home/$website/public_html/wp-config-sample.php
wp core config --dbname=$dataname --dbuser=$username --dbpass=$password --allow-root
#perl -pi -e "s/= 'wp_';/= 'wp_${randomwp}_';/g" wp-config.php
wp core install --url="http://$website" --title="$website"  --admin_user="$adminwp" --admin_password="$passwp" --admin_email="admin@$website" --allow-root
wp plugin install wp-super-cache --activate --allow-root
wp plugin install wp-limit-login-attempts --allow-root
wp plugin install no-category-base-wpml --activate --allow-root
sed -i "/.*DB_COLLATE*./a\//* Authentication Unique Keys and Salts." /home/$website/public_html/wp-config.php
#echo "define('FS_METHOD','direct');" >> /home/$website/public_html/wp-config.php
cd
chown -R ${webuser}:${webuser} "/home/$website/public_html/"
find /home/$website/public_html/ -type d -exec chmod g+s {} \;
#/etc/lemp/menu/lemp-re-config-cac-ham-php-disable-php.ini

systemctl restart nginx
systemctl restart php${PHP_VERSION}-fpm.service

clear
echo "========================================================================="
echo "Them $website va cai dat wordpress thanh cong"
echo "-------------------------------------------------------------------------"
echo "Home Folder: /home/$website/public_html"
echo "-------------------------------------------------------------------------"
echo "Vhost File: /etc/nginx/conf.d/$website.conf"
echo "-------------------------------------------------------------------------"
echo "Thong tin tai khoan Admin:"
echo "-------------------------------------------------------------------------"
echo "User: $adminwp  ||  Password: $passwp"
echo "email: admin@$website"
echo "-------------------------------------------------------------------------"
echo "Ban co the thay doi email trong  Wp-admin Dasboard !"
echo "-------------------------------------------------------------------------"
echo "Thong tin database da duoc luu vao: /home/DBinfo.txt"
/etc/lemp/menu/lemp-them-website-menu.sh
