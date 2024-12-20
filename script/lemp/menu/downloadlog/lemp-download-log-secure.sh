#!/bin/bash
. /home/lemp.conf
random=`date |md5sum |cut -c '1-10'`
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
sleep 1
echo "-------------------------------------------------------------------------"
if [ -f /var/log/secure ]; then
minimumsize=1024000
 checksize=$(du -sb /var/log/secure | awk 'NR==1 {print $1}')
	if [ "$checksize" = "0" ]; then
	clear
	echo "========================================================================= "
	echo "Khong co du lieu trong Secure log file"
	/etc/lemp/menu/downloadlog/lemp-error-menu.sh
	fi
	if [ $checksize -ge $minimumsize ]; then
	rm -rf /home/$mainsite/private_html/server-log/log-secure.log*
	\cp -uf /var/log/secure /home/$mainsite/private_html/server-log/
	cd /home/$mainsite/private_html/server-log
		sed -i '1s/^/========================================================================= \n\n/' secure
	sed -i '2s/^/Secure Log - Created by LEMP \n\n/' secure
	sed -i '3s/^/========================================================================= \n\n/' secure
	zip log-secure.log-$random.zip secure
	rm -rf secure
	cd
	chmod -R 755 /home/$mainsite/private_html/server-log/*
	clear
	echo "========================================================================= "
	echo "Link download Secure Log:"
	echo "-------------------------------------------------------------------------"
	echo "http://$serverip:$priport/server-log/log-secure.log-$random.zip"
	/etc/lemp/menu/downloadlog/lemp-error-menu.sh
  else
    rm -rf /home/$mainsite/private_html/server-log/log-secure.log*
	\cp -uf /var/log/secure /home/$mainsite/private_html/server-log/
	cd /home/$mainsite/private_html/server-log
	mv secure log-secure.log-$random.txt	
	sed -i '1s/^/========================================================================= \n\n/' log-secure.log-$random.txt
	sed -i '2s/^/Secure Log - Created by LEMP \n\n/' log-secure.log-$random.txt
	sed -i '3s/^/========================================================================= \n\n/' log-secure.log-$random.txt
	cd
	chmod -R 755 /home/$mainsite/private_html/server-log/*
	clear
	echo "========================================================================= "
	echo "Link Xem Secure Log:"
	echo "-------------------------------------------------------------------------"
	echo "http://$serverip:$priport/server-log/log-secure.log-$random.txt"
	/etc/lemp/menu/downloadlog/lemp-error-menu.sh
  fi 
else
clear
echo "========================================================================= "
echo "File log khong ton tai hoac ban Disable chuc nang ghi log"
/etc/lemp/menu/downloadlog/lemp-error-menu.sh
fi 
