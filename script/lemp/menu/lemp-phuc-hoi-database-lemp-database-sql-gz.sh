#!/bin/sh
. /home/lemp.conf
website=$(cat /tmp/lemp-tensitephuchoi)
dataname=$(cat /tmp/lemp-tendatabasephuchoi)
randomcode=`date |md5sum |cut -c '1-18'`
echo "========================================================================="
	echo "Tim thay file backup lemp-DATABASE.sql.gz"
	echo "-------------------------------------------------------------------------"
	echo "Chuan bi phuc hoi .... "
	sleep 2
	gunzip < /home/$website/public_html/lemp-DATABASE.sql.gz | mysql -u root -p$mariadbpass $dataname
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
		/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
		else	
		rm -rf /tmp/*lemp*
		mv /home/$website/public_html/lemp-DATABASE.sql.gz /home/$website/public_html/lemp-DATABASE.sql.gz.$randomcode
		clear
		echo "========================================================================="
		echo "Phuc hoi database $dataname thanh cong !"
		echo "-------------------------------------------------------------------------"
		echo "File backup duoc doi ten thanh lemp-DATABASE.sql.gz.$randomcode"
		/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
		exit
		fi
