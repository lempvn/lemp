#!/bin/sh
. /home/lemp.conf
if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
	if [ "$(/sbin/service nginx status | awk 'NR==1 {print $5}')" == "running..." ]; then
clear
/etc/lemp/menu/pagespeed/lemp-pagespeed-menu.sh
	else
service nginx start
		if [ "$(/sbin/service nginx status | awk 'NR==1 {print $5}')" == "running..." ]; then
clear
/etc/lemp/menu/pagespeed/lemp-pagespeed-menu.sh
		else
	clear
	echo "========================================================================="
	echo "Rat tiec, Nginx dang stopped. Hay bat len truoc khi dung chuc nang nay!"
	#echo "Sorry, Nginx is stopped. Please start it before use this function !"
	lemp
		fi
fi
fi

#if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "7" ]; then 
if [ ! "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
	if [ "`systemctl is-active nginx.service`" == "active" ]; then
clear
/etc/lemp/menu/pagespeed/lemp-pagespeed-menu.sh
	else
systemctl start nginx.service
	if [ "`systemctl is-active nginx.service`" == "active" ]; then
clear
/etc/lemp/menu/pagespeed/lemp-pagespeed-menu.sh
		else
	clear
	echo "========================================================================="
	echo "Rat tiec, Nginx dang stopped. Hay bat len truoc khi dung chuc nang nay!"
	#echo "Sorry, Nginx is stopped. Please start it before use this function !"
	lemp
		fi
fi
fi
