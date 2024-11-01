#!/bin/bash
. /home/lemp.conf
echo "========================================================================="
echo "Su dung chuc nang nay de phuc hoi database co dinh dang .sql.gz "
echo "========================================================================="
echo -n "Nhap ten website: " 
read website
website=`echo $website | tr '[A-Z]' '[a-z]'`
if [ "$website" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai "
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
kiemtradomain3="^([[:alnum:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)+[[:alpha:]]{2,14}$";
if [[ ! "$website" =~ $kiemtradomain3 ]]; then
	website=`echo $website | tr '[A-Z]' '[a-z]'`
clear
echo "========================================================================="
echo "$website Co the khong dung dinh dang domain!"
echo "-------------------------------------------------------------------------"
echo "Ban hay lam lai !"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
if [ ! -f /etc/nginx/conf.d/$website.conf ]; then
clear
echo "========================================================================="
echo "$website khong ton tai tren he thong!"
echo "-------------------------------------------------------------------------"
echo "Ban hay lam lai"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
if [ -f /home/$website/public_html/wp-config-sample.php ]; then
if [ ! -f /home/$website/public_html/wp-config.php ]; then
clear
echo "========================================================================="
echo "$website co code wordpress nhung chua cai dat !"
echo "-------------------------------------------------------------------------"
echo "Hay cai dat wordpress va thu lai !"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
fi
if [ ! -f /home/$website/public_html/wp-config.php ]; then
clear
echo "========================================================================="
echo "$website khong phai wordpress blog !"
echo "-------------------------------------------------------------------------"
echo "Ban hay lam lai."
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
tendatabase=`cat /home/$website/public_html/wp-config.php | grep DB_NAME | cut -d \' -f 4`
randomwp=`date |md5sum |cut -c '1-18'`
date -r /var/lib/mysql/$tendatabase +%H%M%S> /tmp/lemp1
echo "-------------------------------------------------------------------------"
echo "Tim thay $website tren he thong"
echo "-------------------------------------------------------------------------"
echo "$website su dung wordpress code"
echo "-------------------------------------------------------------------------"
echo "Please wait ...."
echo "-------------------------------------------------------------------------"

if [ -f /home/$website/public_html/lemp-DATABASE.sql.gz ]; then
echo "Tim thay file backup lemp-DATABASE.sql.gz"
echo "-------------------------------------------------------------------------"
echo "Chuan bi phuc hoi .... "
echo "-------------------------------------------------------------------------"
sleep 2
gunzip < /home/$website/public_html/lemp-DATABASE.sql.gz | mysql -u root -p$mariadbpass $tendatabase
date -r /var/lib/mysql/$dataname +%H%M%S> /tmp/lemp2
check1=`cat /tmp/lemp1`
check2=`cat /tmp/lemp2`

if [ "$check1" == "$check2" ]; then
	rm -rf /tmp/lemp1
	rm -rf /tmp/lemp2
	clear
	echo "========================================================================="
	echo "Phuc hoi database $tendataname that bai "
	echo "-------------------------------------------------------------------------"
	echo "Hay check file backup va lam lai !"
	/etc/lemp/menu/lemp-wordpress-tools-menu.sh
	else	
	rm -rf /tmp/lemp1
	rm -rf /tmp/lemp2
	clear
	echo "========================================================================="
	echo "Phuc hoi database $tendatabase thanh cong !"
	mv /home/$website/public_html/lemp-DATABASE.sql.gz /home/$website/public_html/lemp-DATABASE.sql.gz.$randomwp
	echo "-------------------------------------------------------------------------"
	echo "File backup duoc doi ten thanh lemp-DATABASE.sql.gz.$randomwp"
	/etc/lemp/menu/lemp-wordpress-tools-menu.sh
	fi
else
	clear
	echo "========================================================================="
	echo "CACH PHUC HOI"
	echo "========================================================================="
	echo "Chuc nang nay chi phuc hoi duoc database co dinh dang .sql.gz"
	echo "-------------------------------------------------------------------------"
	echo "Ban hay doi ten file backup thanh lemp-DATABASE.sql.gz va upload vao: "
	echo "-------------------------------------------------------------------------"
	echo "/home/$website/public_html/"
	echo "========================================================================="
	read -p "Upload file xong. Nhan [Enter] de phuc hoi ..."
	echo "-------------------------------------------------------------------------"
	echo "LEMP dang tim file Backup .... "
	echo "-------------------------------------------------------------------------"
	sleep 4
	if [ -f /home/$website/public_html/lemp-DATABASE.sql.gz ]; then
echo "Tim thay file backup lemp-DATABASE.sql.gz"
echo "-------------------------------------------------------------------------"
echo "Chuan bi phuc hoi .... "
echo "-------------------------------------------------------------------------"
sleep 2
gunzip < /home/$website/public_html/lemp-DATABASE.sql.gz | mysql -u root -p$mariadbpass $tendatabase
date -r /var/lib/mysql/$dataname +%H%M%S> /tmp/lemp2
check1=`cat /tmp/lemp1`
check2=`cat /tmp/lemp2`

if [ "$check1" == "$check2" ]; then
	rm -rf /tmp/lemp1
	rm -rf /tmp/lemp2
	clear
	echo "========================================================================="
	echo "Phuc hoi database $tendatabase that bai "
	echo "-------------------------------------------------------------------------"
	echo "Hay check file backup va lam lai !"
	/etc/lemp/menu/lemp-wordpress-tools-menu.sh
	else	
	rm -rf /tmp/lemp1
	rm -rf /tmp/lemp2
	clear
	echo "========================================================================="
	echo "Phuc hoi database $tendatabase thanh cong !"
	mv /home/$website/public_html/lemp-DATABASE.sql.gz /home/$website/public_html/lemp-DATABASE.sql.gz.$randomwp
	echo "-------------------------------------------------------------------------"
	echo "File backup duoc doi ten thanh lemp-DATABASE.sql.gz.$randomwp"
	/etc/lemp/menu/lemp-wordpress-tools-menu.sh
	fi
else
clear
echo "=========================================================================" 
echo "Khong tim thay lemp-DATABASE.sql.gz !"
echo "-------------------------------------------------------------------------"
echo "Hay upload file backup len va thu lai"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
fi
fi
