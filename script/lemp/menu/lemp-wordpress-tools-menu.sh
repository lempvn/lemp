#!/bin/bash
. /home/lemp.conf

PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")

if [ ! -f /usr/local/bin/htpasswd.py ]; then
cp -r /etc/lemp/menu/lemp-tao-mat-khau-bao-ve-folder.py /usr/local/bin/htpasswd.py
chmod 755 /usr/local/bin/htpasswd.py
fi
if [ ! -f /etc/lemp/pwprotect.default ]; then
echo "" > /etc/lemp/pwprotect.default
fi
if [ -f /var/lib/mysql/lempCheckDB/db.opt ]; then
rm -rf /var/lib/mysql/lempCheckDB
fi

menu_wordpress_blog_tools () {

prompt="Lua chon cua ban (0-Thoat):"
options=("Update Wordpress An Toan" "Update Themes & Plugins" "Tat/Bat Auto Update WP Code" "Tat/Bat WP-Cron.php" "Xem Themes & Plugins Status" "Enable Redis Cache" "Disable Redis Cache" "Sao Luu Database" "Phuc Hoi Database" "Cai Dat Wordpress Multisite" "Tao Vhost Cho WP MultiSite" "Cau Hinh Vhost Cho PLugin Cache" "Xem Thong Tin Database" "Toi Uu - Sua Loi Database" "Password Bao Ve wp-login.php" "Fix Loi Missed Schedule" "Fix Loi Permission"  ) 
printf "=========================================================================\n"
printf "                LEMP - Quan Ly VPS/Server by LEMP.VN \n"
printf "=========================================================================\n"
printf "                           Wordpress Blog Tools\n"
printf "=========================================================================\n"

PS3="$prompt"
select opt in "${options[@]}" "Thoat"; do 

    case "$REPLY" in
    1 ) /etc/lemp/menu/lemp-update-code-wordpress-menu-wordpress.sh;;
    2) /etc/lemp/menu/lemp-update-themes-plugins-wordpress-menu-wordpress.sh;;
    3)  /etc/lemp/menu/lemp-enable-disable-tu-dong-update-wordpress.sh;;
    4) /etc/lemp/menu/lemp-enable-disable-wp-cron.php-wordpress;;
    5) /etc/lemp/menu/lemp-xem-danh-sach-plugins-website-wordpress.sh;;
    6) /etc/lemp/menu/lemp-enable-redis-cho-wordpress-website.sh;;
    7) /etc/lemp/menu/lemp-disable-redis-cho-wordpress-website.sh;;
    8) /etc/lemp/menu/lemp-sao-luu-database-wordpress.sh;;
    9) /etc/lemp/menu/lemp-phuc-hoi-database-chon-dinh-dang-wordpress.sh;;
    10) /etc/lemp/menu/lemp-cai-dat-multisite-menu-wordpress.sh;;
    11) /etc/lemp/menu/lemp-kich-hoat-sub-multisite-wordpress.sh;;
    12) /etc/lemp/menu/lemp-re-config-vhost-cho-website-wordpress.sh;;
    13) /etc/lemp/menu/lemp-xem-thong-tin-database-wordpress.sh;;
    14)  /etc/lemp/menu/lemp-toi-uu-repair-database-wordpress.sh;;
    15) /etc/lemp/menu/lemp-dat-mat-khau-bao-ve-wp-login.sh;;
    16) /etc/lemp/menu/lemp-fix-loi-missed-schedule-wordpress.sh;;
    17) /etc/lemp/menu/lemp-sua-loi-permision-chmod-chown-wordpress.sh;;
    
    
    $(( ${#options[@]}+1 )) ) echo "";  clear && /bin/lemp;;
    0 ) echo "";  clear && /bin/lemp;;
    *) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu";continue;;

    esac
done

}

check_wpcli_version () {
if [ ! -f /usr/local/bin/wp ]; then
echo "========================================================================="
echo "Installing  WP-CLI" ; sleep 2
#wget -q --no-check-certificate https://lemp.com/script/lemp/Softwear/wp-cli.phar
#wget -q --no-check-certificate https://github.com/itvn9online/lemp-free/raw/master/script/lemp/Softwear/wp-cli.phar
#wget -q --no-check-certificate https://github.com/vpsvn/vps-vps-software/raw/main/wp-cli.phar
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
wp --version --allow-root > /etc/lemp/wpcli.version 
fi

if [ ! -f /etc/lemp/wpcli.version ]; then
touch -a -m -t 201601180130.09 /etc/lemp/wpcli.version
fi

fileTime3=$(date -r /etc/lemp/wpcli.version +%d)
curTime3=$(date +%d)
if [ ! "$fileTime3" == "$curTime3" ]; then
wp --version --allow-root > /etc/lemp/wpcli.version 
wp_cli_update=`wp cli check-update --allow-root | awk 'NR==1 {print $1}'`
if [ ! "$wp_cli_update" = "Success:" ]; then
echo "========================================================================="
echo "Update for WP-CLI Found ! Updating WP-CLI ..." ; 
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
sleep 4
#/etc/lemp/menu/lemp-enable-tat-ca-cac-ham-php-php.ini
echo y | wp cli update --allow-root
wp --version --allow-root > /etc/lemp/wpcli.version 
#/etc/lemp/menu/lemp-re-config-cac-ham-php-disable-php.ini
menu_wordpress_blog_tools
else
menu_wordpress_blog_tools
fi
else
menu_wordpress_blog_tools
fi
}


check_mariaDB_service () {
if [ -f /var/lib/mysql/lempCheckDB/db.opt ]; then
rm -rf /var/lib/mysql/lempCheckDB
fi
 cat > "/tmp/config.temp" <<END
CREATE DATABASE lempCheckDB COLLATE utf8_general_ci;
END
mariadb -u root -p$mariadbpass < /tmp/config.temp
rm -f /tmp/config.temp

if [ ! -f /var/lib/mysql/lempCheckDB/db.opt ]; then
clear
echo "========================================================================"
echo "MySQL service is not running"
echo "------------------------------------------------------------------------"
echo "LEMP trying to start it"
echo "------------------------------------------------------------------------"
echo "Please wait ..."
sleep 5 ; clear
rm -rf /var/lib/mysql/ib_logfile0
rm -rf /var/lib/mysql/ib_logfile1
cat > "/tmp/startmysql" <<END
systemctl start mariadb.service
service mysql start
END
chmod +x /tmp/startmysql
/tmp/startmysql
rm -rf /tmp/startmysql
clear
echo "========================================================================"
echo "Check MySQL service once again !"
echo "------------------------------------------------------------------------"
echo "please wait ..."
sleep 5 ; clear
cat > "/tmp/config.temp" <<END
CREATE DATABASE lempCheckDB COLLATE utf8_general_ci;
END
mariadb -u root -p$mariadbpass < /tmp/config.temp
rm -f /tmp/config.temp
	if [ ! -f /var/lib/mysql/lempCheckDB/db.opt ]; then
clear
echo "========================================================================"
echo "LEMP can not start MySQL Service"
sleep 4 ;
	clear
	echo "========================================================================="
	echo "Sorry, MariaDB dang stopped. Hay bat len truoc khi dung chuc nang nay!"
		#echo "Sorry, MySQL stopped. Start it before use this function!"
	lemp
	else
	rm -rf /var/lib/mysql/lempCheckDB
check_wpcli_version 
	fi
else
rm -rf /var/lib/mysql/lempCheckDB
check_wpcli_version 
fi
}

check_php_fpm_service () {


#if [ "$(/sbin/service php${PHP_VERSION}-fpm status | awk 'NR==1 {print $5}')" == "running..." ]; then

if systemctl is-active --quiet php${PHP_VERSION}-fpm; then
check_mariaDB_service
else
clear
echo "========================================================================"
echo "PHP${PHP_VERSION}-FPM service is not running"
echo "------------------------------------------------------------------------"
echo "LEMP trying to start it"
echo "------------------------------------------------------------------------"
echo "Please wait ..."
sleep 5 ; clear
echo "-------------------------------------------------------------------------"
systemctl restart php${PHP_VERSION}-fpm
clear
echo "========================================================================"
echo "Check PHP${PHP_VERSION}-FPM service once again !"
echo "------------------------------------------------------------------------"
echo "please wait ..."
sleep 5 ; clear
#if [ "$(/sbin/service php${PHP_VERSION}-fpm status | awk 'NR==1 {print $5}')" == "running..." ]; then

if systemctl is-active --quiet php${PHP_VERSION}-fpm; then
check_mariaDB_service
else
clear
echo "========================================================================"
echo "LEMP khong the khoi dong PHP${PHP_VERSION}-FPM Service"
sleep 4 ;
	clear
	echo "========================================================================="
	#echo "Sorry, PHP-FPM stopped. Start it before use this function!"
	echo "Sorry, PHP-FPM dang stopped. Hay bat len truoc khi dung chuc nang nay!"
	lemp
fi
fi

}


#if [ "$(/sbin/service nginx status | awk 'NR==1 {print $5}')" == "running..." ]; then
#check_php_fpm_service

if systemctl is-active --quiet nginx; then
    check_php_fpm_service
else
clear
echo "========================================================================"
echo "Nginx service is not running"
echo "------------------------------------------------------------------------"
echo "LEMP trying to start it"
echo "------------------------------------------------------------------------"
echo "Please wait ..."
sleep 5 ; clear
echo "-------------------------------------------------------------------------"
systemctl restart nginx
clear
echo "========================================================================"
echo "Check Nginx service once again !"
echo "------------------------------------------------------------------------"
echo "please wait ..."
sleep 5 ; clear

#if [ "$(/sbin/service nginx status | awk 'NR==1 {print $5}')" == "running..." ]; then
#check_php_fpm_service

if systemctl is-active --quiet nginx; then
check_php_fpm_service
else
clear
echo "========================================================================"
echo "LEMP khong the khoi dong Nginx Service"
sleep 4 ;
clear
echo "========================================================================="
echo "Rat tiec, Nginx dang stopped. Hay bat len truoc khi dung chuc nang nay!"
#echo "Sorry, Nginx is stopped. Please start it before use this function !"
lemp
fi
fi



