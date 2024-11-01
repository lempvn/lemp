#!/bin/bash
. /home/lemp.conf
random=`date |md5sum |cut -c '1-10'`
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
sleep 1
echo "-------------------------------------------------------------------------"

if [ -f /home/$mainsite/logs/mysql.log ]; then
minimumsize=1024000
 checksize=$(du -sb /home/$mainsite/logs/mysql.log | awk 'NR==1 {print $1}')
	if [ "$mysqllogsize1" = "0" ]; then
	clear
	echo "========================================================================= "
	echo "Khong co du lieu trong MySQL log file"
	/etc/lemp/menu/downloadlog/lemp-error-menu.sh
	fi
	
	if [ $checksize -ge $minimumsize ]; then
	rm -rf /home/$mainsite/private_html/server-log/mysql.log*
	\cp -uf /home/$mainsite/logs/mysql.log /home/$mainsite/private_html/server-log
	cd /home/$mainsite/private_html/server-log
			sed -i '1s/^/========================================================================= \n\n/' mysql.log
	sed -i '2s/^/MySQL Log - Created by LEMP \n\n/' mysql.log
	sed -i '3s/^/========================================================================= \n\n/' mysql.log
	zip mysql.log-$random.zip mysql.log
	rm -rf mysql.log
	cd
	chmod -R 755 /home/$mainsite/private_html/server-log/*
	clear
	echo "========================================================================= "
	echo "Link download Mysql Log:"
	echo "-------------------------------------------------------------------------"
	echo "http://$serverip:$priport/server-log/mysql.log-$random.zip"
	/etc/lemp/menu/downloadlog/lemp-error-menu.sh
  else
    rm -rf /home/$mainsite/private_html/server-log/mysql.log*
	\cp -uf /home/$mainsite/logs/mysql.log /home/$mainsite/private_html/server-log
	cd /home/$mainsite/private_html/server-log
	mv mysql.log mysql.log-$random.txt
		sed -i '1s/^/========================================================================= \n\n/' mysql.log-$random.txt
	sed -i '2s/^/MySQL Log - Created by LEMP \n\n/' mysql.log-$random.txt
	sed -i '3s/^/========================================================================= \n\n/' mysql.log-$random.txt
	cd
	chmod -R 755 /home/$mainsite/private_html/server-log/*
	clear
	echo "========================================================================= "
	echo "Link Xem Mysql Log:"
	echo "-------------------------------------------------------------------------"
	echo "http://$serverip:$priport/server-log/mysql.log-$random.txt"
	/etc/lemp/menu/downloadlog/lemp-error-menu.sh
  fi 
else
clear
echo "========================================================================= "
echo "File log khong ton tai hoac ban Disable chuc nang ghi log."
/etc/lemp/menu/downloadlog/lemp-error-menu.sh
fi 
