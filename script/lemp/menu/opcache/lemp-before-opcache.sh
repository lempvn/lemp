#!/bin/sh
. /home/lemp.conf
if [ -f /etc/php.d/opcache.bak ]; then
if [ -f	/etc/php.d/*opcache.ini ]; then
rm -rf /etc/php.d/*opcache.ini
fi 
fi
if [ -f /etc/php.d/opcache.ini ]; then
find /etc/php.d -name '*opcache.ini' > /tmp/lempcheckopcache.tmp
checkopcache=$(cat /tmp/lempcheckopcache.tmp | wc -l)
if [ ! "$checkopcache" == "1" ]; then
rm -rf /tmp/lempopcache
mkdir -p /tmp/lempopcache
cp -r /etc/php.d/opcache.ini /tmp/lempopcache
rm -rf /etc/php.d/*opcache.ini
cp -r /tmp/lempopcache/opcache.ini /etc/php.d
rm -rf /tmp/lempopcache
rm -rf /tmp/lempcheckopcache.tmp
fi 
fi
if [ ! -f /etc/lemp/opcache.blacklist ]; then
cat > "/etc/lemp/opcache.blacklist" <<END
/home/$mainsite/
/home/*/public_html/wp-content/plugins/backwpup/*
/home/*/public_html/wp-content/plugins/duplicator/*
/home/*/public_html/wp-content/plugins/updraftplus/*
END
fi

zen_opcache_run () {
	if [ -f /etc/php.d/opcache.ini ]; then
if [ "$(grep opcache.blacklist /etc/php.d/opcache.ini)" == "" ]; then
echo "opcache.blacklist_filename=/etc/lemp/opcache.blacklist" >> /etc/php.d/opcache.ini
fi 
/etc/lemp/menu/opcache/lemp-dang-bat-opcache-menu.sh
fi
if [ -f /etc/php.d/opcache.bak ]; then
if [ "$(grep opcache.blacklist /etc/php.d/opcache.bak)" == "" ]; then
echo "opcache.blacklist_filename=/etc/lemp/opcache.blacklist" >> /etc/php.d/opcache.bak
fi 
/etc/lemp/menu/opcache/lemp-dang-tat-opcache-menu.sh
fi
clear
echo "========================================================================="
echo "LEMP can not find zend opcache in your system"
lemp
}

if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
	if [ "$(/sbin/service php-fpm status | awk 'NR==1 {print $5}')" == "running..." ]; then
zen_opcache_run
	else
service php-fpm start
			if [ "$(/sbin/service php-fpm status | awk 'NR==1 {print $5}')" == "running..." ]; then
zen_opcache_run
		else
	clear
	echo "========================================================================="
	#echo "Sorry, PHP-FPM stopped. Start it before use this function!"
	echo "Sorry, PHP-FPM dang stopped. Hay bat len truoc khi dung chuc nang nay!"
	lemp
		fi
fi
fi

#if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "7" ]; then 
if [ ! "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
	if [ "`systemctl is-active php-fpm.service`" == "active" ]; then
zen_opcache_run
	else
systemctl start php-fpm.service
	if [ "`systemctl is-active php-fpm.service`" == "active" ]; then
zen_opcache_run
		else
	clear
	echo "========================================================================="
	#echo "Sorry, PHP-FPM stopped. Start it before use this function!"
	echo "Sorry, PHP-FPM dang stopped. Hay bat len truoc khi dung chuc nang nay!"
	lemp
		fi
fi
fi





