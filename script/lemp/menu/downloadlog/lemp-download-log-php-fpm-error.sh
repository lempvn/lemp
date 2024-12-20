#!/bin/bash
. /home/lemp.conf
random=`date |md5sum |cut -c '1-10'`
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
sleep 1
echo "-------------------------------------------------------------------------"
if [ -f /home/$mainsite/logs/php-fpm-error.log ]; then
minimumsize=1024000
 checksize=$(du -sb /home/$mainsite/logs/php-fpm-error.log | awk 'NR==1 {print $1}')
	if [ "$checksize" = "0" ]; then
	clear
	echo "========================================================================= "
	echo "Khong co du lieu trong PHP-FPM Error log file"
	/etc/lemp/menu/downloadlog/lemp-error-menu.sh
	fi
	
	if [ $checksize -ge $minimumsize ]; then
	rm -rf /home/$mainsite/private_html/server-log/php-fpm-error.log*
	\cp -uf /home/$mainsite/logs/php-fpm-error.log /home/$mainsite/private_html/server-log
	cd /home/$mainsite/private_html/server-log
		sed -i '1s/^/========================================================================= \n\n/' php-fpm-error.log
	sed -i '2s/^/PHP-FPM Error Log - Created by LEMP \n\n/' php-fpm-error.log
	sed -i '3s/^/========================================================================= \n\n/' php-fpm-error.log
	zip php-fpm-error.log-$random.zip php-fpm-error.log
	rm -rf php-fpm-error.log
	cd
	chmod -R 755 /home/$mainsite/private_html/server-log/*
	clear
	echo "========================================================================= "
	echo "Link download PHP-FPM Error Log:"
	echo "-------------------------------------------------------------------------"
	echo "http://$serverip:$priport/server-log/php-fpm-error.log-$random.zip"
	/etc/lemp/menu/downloadlog/lemp-error-menu.sh
  else
    rm -rf /home/$mainsite/private_html/server-log/php-fpm-error.log*
	\cp -uf /home/$mainsite/logs/php-fpm-error.log /home/$mainsite/private_html/server-log/
	cd /home/$mainsite/private_html/server-log
	mv php-fpm-error.log php-fpm-error.log-$random.txt	
	sed -i '1s/^/========================================================================= \n\n/' php-fpm-error.log-$random.txt
	sed -i '2s/^/PHP-FPM Error Log - Created by LEMP \n\n/' php-fpm-error.log-$random.txt
	sed -i '3s/^/========================================================================= \n\n/' php-fpm-error.log-$random.txt
	cd
	chmod -R 755 /home/$mainsite/private_html/server-log/*
	clear
	echo "========================================================================= "
	echo "Link Xem PHP-FPM Error Log:"
	echo "-------------------------------------------------------------------------"
	echo "http://$serverip:$priport/server-log/php-fpm-error.log-$random.txt"
	/etc/lemp/menu/downloadlog/lemp-error-menu.sh
  fi 
  
else
clear
echo "========================================================================= "
echo "File log khong ton tai hoac ban Disable chuc nang ghi log"
/etc/lemp/menu/downloadlog/lemp-error-menu.sh
fi 
