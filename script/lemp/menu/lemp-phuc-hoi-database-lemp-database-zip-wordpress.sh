#!/bin/sh
. /home/lemp.conf
website=$(cat /tmp/lemp-tensitephuchoi)
dataname=$(cat /tmp/lemp-tendatabasephuchoi)
randomcode=`date |md5sum |cut -c '1-18'`
echo "========================================================================="
	echo "Tim thay file backup lemp-DATABASE.zip"
	echo "-------------------------------------------------------------------------"
	echo "Chuan bi phuc hoi .... "
	echo "-------------------------------------------------------------------------"
	sleep 2
	rm -rf /tmp/lemp-sql
	mkdir -p /tmp/lemp-sql
	unzip /home/$website/public_html/lemp-DATABASE.zip -d /tmp/lemp-sql
	ls /tmp/lemp-sql > /tmp/lemp-datasql-name
	tenbackup=$(cat /tmp/lemp-datasql-name)
	mysql -u root -p$mariadbpass $dataname < /tmp/lemp-sql/$tenbackup > /tmp/abc
	date -r /var/lib/mysql/$dataname +%H%M%S> /tmp/lemp2
	rm -rf /tmp/lemp-sql/$tenbackup
	check1=`cat /tmp/lemp1`
	check2=`cat /tmp/lemp2`
		if [ "$check1" == "$check2" ]; then
		rm -rf /tmp/*lemp*
		sleep 8
		clear
		echo "========================================================================="
		echo "Phuc hoi database $dataname that bai "
		echo "-------------------------------------------------------------------------"
		echo "Vui long kiem tra file backup va thu lai !"
		/etc/lemp/menu/lemp-wordpress-tools-menu.sh
		else	
		rm -rf /tmp/*lemp*
		mv /home/$website/public_html/lemp-DATABASE.zip /home/$website/public_html/lemp-DATABASE.zip.$randomcode
		clear
		echo "========================================================================="
		echo "Phuc hoi database $dataname thanh cong !"
		echo "-------------------------------------------------------------------------"
		echo "File backup duoc doi ten thanh lemp-DATABASE.zip.$randomcode"
		/etc/lemp/menu/lemp-wordpress-tools-menu.sh
		exit
		fi
