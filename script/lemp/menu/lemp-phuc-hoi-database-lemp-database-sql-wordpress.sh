#!/bin/sh
. /home/lemp.conf
website=$(cat /tmp/lemp-tensitephuchoi)
dataname=$(cat /tmp/lemp-tendatabasephuchoi)
randomcode=`date |md5sum |cut -c '1-18'` 
echo "========================================================================="   
	echo "Tim thay file backup lemp-DATABASE.sql"
	echo "-------------------------------------------------------------------------"
	echo "Chuan bi phuc hoi .... "
	echo "-------------------------------------------------------------------------"
	sleep 2
	mysql -u root -p$mariadbpass $dataname < /home/$website/public_html/lemp-DATABASE.sql
	date -r /var/lib/mysql/$dataname +%H%M%S> /tmp/lemp2
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
		mv /home/$website/public_html/lemp-DATABASE.sql /home/$website/public_html/lemp-DATABASE.sql.$randomcode
		clear
		echo "========================================================================="
		echo "Phuc hoi database $dataname thanh cong !"
		echo "-------------------------------------------------------------------------"
		echo "File backup duoc doi ten thanh lemp-DATABASE.sql.$randomcode"
		/etc/lemp/menu/lemp-wordpress-tools-menu.sh
		exit
		fi
