#!/bin/sh
. /home/lemp.conf
if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
	if [ "$(/sbin/service php-fpm status | awk 'NR==1 {print $5}')" == "running..." ]; then
/etc/lemp/menu/tienich/lemp-ioncube-cai-dat-remove
	else
	echo "-------------------------------------------------------------------------"
service php-fpm start
			if [ "$(/sbin/service php-fpm status | awk 'NR==1 {print $5}')" == "running..." ]; then
/etc/lemp/menu/tienich/lemp-ioncube-cai-dat-remove
		else
clear
echo "========================================================================="
echo "PHP-FPM Khong the khoi dong"
echo "-------------------------------------------------------------------------"
echo "Ban khong the cai dat hay Remove Ioncube Loader."
/etc/lemp/menu/tienich/lemp-tien-ich.sh
		fi
fi
fi

#if [ "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "7" ]; then 
if [ ! "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then 
	if [ "`systemctl is-active php-fpm.service`" == "active" ]; then
/etc/lemp/menu/tienich/lemp-ioncube-cai-dat-remove
	else
systemctl start php-fpm.service
	if [ "`systemctl is-active php-fpm.service`" == "active" ]; then
/etc/lemp/menu/tienich/lemp-ioncube-cai-dat-remove
		else
clear
echo "========================================================================="
echo "PHP-FPM Khong the khoi dong"
echo "-------------------------------------------------------------------------"
echo "Ban khong the cai dat hay Remove Ioncube Loader."
/etc/lemp/menu/tienich/lemp-tien-ich.sh
		fi
fi
fi
