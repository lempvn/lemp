#!/bin/bash
. /home/lemp.conf
random=`date |md5sum |cut -c '1-10'`
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
sleep 1
echo "-------------------------------------------------------------------------"
if [ -f /home/$mainsite/logs/php-fpm.log ]; then
minimumsize=1024000
 checksize=$(du -sb /home/$mainsite/logs/php-fpm.log | awk 'NR==1 {print $1}')
	if [ "$checksize" = "0" ]; then
	clear
	echo "========================================================================= "
	echo "Khong co du lieu trong PHP-FPM log file"
	/etc/lemp/menu/downloadlog/lemp-eroor-menu
	fi
	
	if [ $checksize -ge $minimumsize ]; then
	rm -rf /home/$mainsite/private_html/server-log/php-fpm.log*
	\cp -uf /home/$mainsite/logs/php-fpm.log /home/$mainsite/private_html/server-log
	cd /home/$mainsite/private_html/server-log
		sed -i '1s/^/========================================================================= \n\n/' php-fpm.log
	sed -i '2s/^/PHP-FPM Log - Created by LEMP \n\n/' php-fpm.log
	sed -i '3s/^/========================================================================= \n\n/' php-fpm.log
	zip php-fpm.log-$random.zip php-fpm.log
	rm -rf php-fpm.log
	cd
	chmod -R 755 /home/$mainsite/private_html/server-log/*
	clear
	echo "========================================================================= "
	echo "Link download PHP-FPM Log:"
	echo "-------------------------------------------------------------------------"
	echo "http://$serverip:$priport/server-log/php-fpm.log-$random.zip"
	/etc/lemp/menu/downloadlog/lemp-eroor-menu
  else
    rm -rf /home/$mainsite/private_html/server-log/php-fpm.log*
	\cp -uf /home/$mainsite/logs/php-fpm.log /home/$mainsite/private_html/server-log/
	cd /home/$mainsite/private_html/server-log
	mv php-fpm.log php-fpm.log-$random.txt	
	sed -i '1s/^/========================================================================= \n\n/' php-fpm.log-$random.txt
	sed -i '2s/^/PHP-FPM Log - Created by LEMP \n\n/' php-fpm.log-$random.txt
	sed -i '3s/^/========================================================================= \n\n/' php-fpm.log-$random.txt
	cd
	chmod -R 755 /home/$mainsite/private_html/server-log/*
	clear
	echo "========================================================================= "
	echo "Link Xem PHP-FPM Log:"
	echo "-------------------------------------------------------------------------"
	echo "http://$serverip:$priport/server-log/php-fpm.log-$random.txt"
	/etc/lemp/menu/downloadlog/lemp-eroor-menu
  fi 
  
else
clear
echo "========================================================================= "
echo "File log khong ton tai hoac ban Disable chuc nang ghi log"
/etc/lemp/menu/downloadlog/lemp-eroor-menu
fi 
