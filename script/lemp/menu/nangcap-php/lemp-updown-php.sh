#!/bin/sh
. /home/lemp.conf

nang_cap_php_fpm_check () {
/etc/lemp/menu/nangcap-php/change-php-version-menu.sh
}

nang_cap_php_fpm_check_xoa () {
php_version=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")
if [ "$php_version" == "7.0" ]; then
/etc/lemp/menu/nangcap-php/change-php-version-menu.sh
elif [ "$php_version" == "7.1" ]; then
/etc/lemp/menu/nangcap-php/change-php-version-menu.sh
elif [ "$php_version" == "7.2" ]; then
/etc/lemp/menu/nangcap-php/change-php-version-menu.sh
elif [ "$php_version" == "7.3" ]; then
/etc/lemp/menu/nangcap-php/change-php-version-menu.sh
elif [ "$php_version" == "7.4" ]; then
/etc/lemp/menu/nangcap-php/change-php-version-menu.sh
elif [ "$php_version" == "5.6" ]; then
/etc/lemp/menu/nangcap-php/change-php-version-menu.sh
elif [ "$php_version" == "5.5" ]; then
/etc/lemp/menu/nangcap-php/change-php-version-menu.sh
elif [ "$php_version" == "5.4" ]; then
/etc/lemp/menu/nangcap-php/change-php-version-menu.sh
else
clear
echo "========================================================================="
echo "Sorry, LEMP can not check your PHP version"
/etc/lemp/menu/lemp-update-upgrade-service-menu.sh
exit
fi
}

if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
	if [ "$(/sbin/service php-fpm status | awk 'NR==1 {print $5}')" == "running..." ]; then
nang_cap_php_fpm_check
	else
clear
echo "========================================================================"
echo "PHP-FPM service is not running"
echo "------------------------------------------------------------------------"
echo "LEMP trying to start it"
echo "------------------------------------------------------------------------"
echo "Please wait ..."
sleep 5 ; clear
service php-fpm start
clear
echo "========================================================================"
echo "Check PHP-FPM service once again !"
echo "------------------------------------------------------------------------"
echo "please wait ..."
sleep 5 ; clear
			if [ "$(/sbin/service php-fpm status | awk 'NR==1 {print $5}')" == "running..." ]; then
nang_cap_php_fpm_check
		else
	clear
	echo "========================================================================="
	#echo "Sorry, PHP-FPM stopped. Start it before use this function!"
	echo "Sorry, PHP-FPM dang stopped. Hay bat len truoc khi dung chuc nang nay!"
	/etc/lemp/menu/lemp-update-upgrade-service-menu.sh
		fi
fi
fi

#if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "7" ]; then 
if [ ! "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
	if [ "`systemctl is-active php-fpm.service`" == "active" ]; then
nang_cap_php_fpm_check
	else
clear
echo "========================================================================"
echo "PHP-FPM service is not running"
echo "------------------------------------------------------------------------"
echo "LEMP trying to start it"
echo "------------------------------------------------------------------------"
echo "Please wait ..."
sleep 5 ; clear
systemctl start php-fpm.service
clear
echo "========================================================================"
echo "Check PHP-FPM service once again !"
echo "------------------------------------------------------------------------"
echo "please wait ..."
sleep 5 ; clear
	if [ "`systemctl is-active php-fpm.service`" == "active" ]; then
nang_cap_php_fpm_check
		else
	clear
	echo "========================================================================="
	#echo "Sorry, PHP-FPM stopped. Start it before use this function!"
	echo "Sorry, PHP-FPM dang stopped. Hay bat len truoc khi dung chuc nang nay!"
	/etc/lemp/menu/lemp-update-upgrade-service-menu.sh
		fi
fi
fi
