#!/bin/bash
. /home/lemp.conf
random=`date |md5sum |cut -c '1-10'`
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
sleep 1
echo "-------------------------------------------------------------------------"

if [ -f /home/$mainsite/logs/mysql-slow.log ]; then
minimumsize=1024000
 checksize=$(du -sb /home/$mainsite/logs/mysql-slow.log | awk 'NR==1 {print $1}')
	if [ "$checksize" = "0" ]; then
	clear
	echo "========================================================================= "
	echo "Khong co du lieu trong MySQL Slow log file"
	/etc/lemp/menu/downloadlog/lemp-error-menu.sh
	fi
	if [ $checksize -ge $minimumsize ]; then
	rm -rf /home/$mainsite/private_html/server-log/mysql-slow.log*
	\cp -uf /home/$mainsite/logs/mysql-slow.log /home/$mainsite/private_html/server-log/
	cd /home/$mainsite/private_html/server-log
			sed -i '1s/^/========================================================================= \n\n/' mysql-slow.log
	sed -i '2s/^/MySQL Slow Log - Created by LEMP \n\n/' mysql-slow.log
	sed -i '3s/^/========================================================================= \n\n/' mysql-slow.log
	zip mysql-slow.log-$random.zip mysql-slow.log
	rm -rf mysql-slow.log
	cd
	chmod -R 755 /home/$mainsite/private_html/server-log/*
	clear
	echo "========================================================================= "
	echo "Link download Mysql Slow Log:"
	echo "-------------------------------------------------------------------------"
	echo "http://$serverip:$priport/server-log/mysql-slow.log-$random.zip"
	/etc/lemp/menu/downloadlog/lemp-error-menu.sh
  else
    rm -rf /home/$mainsite/private_html/server-log/mysql-slow.log*
	\cp -uf /home/$mainsite/logs/mysql-slow.log /home/$mainsite/private_html/server-log/
	cd /home/$mainsite/private_html/server-log
	mv mysql-slow.log mysql-slow.log-$random.txt
		sed -i '1s/^/========================================================================= \n\n/' mysql-slow.log-$random.txt
	sed -i '2s/^/MySQL Slow Log - Created by LEMP \n\n/' mysql-slow.log-$random.txt
	sed -i '3s/^/========================================================================= \n\n/' mysql-slow.log-$random.txt
	cd
	chmod -R 755 /home/$mainsite/private_html/server-log/*
	clear
	echo "========================================================================= "
	echo "Link Xem Mysql Slow Log:"
	echo "-------------------------------------------------------------------------"
	echo "http://$serverip:$priport/server-log/mysql-slow.log-$random.txt"
	/etc/lemp/menu/downloadlog/lemp-error-menu.sh
  fi 
else
clear
echo "========================================================================= "
echo "File log khong ton tai hoac ban Disable chuc nang ghi log"
/etc/lemp/menu/downloadlog/lemp-error-menu.sh
fi 
