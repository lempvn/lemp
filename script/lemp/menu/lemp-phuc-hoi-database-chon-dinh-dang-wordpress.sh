#!/bin/bash
. /home/lemp.conf
echo "========================================================================="
echo "Su dung chuc nang nay de phuc hoi database cho Wordpress website "
echo "========================================================================="
echo -n "Nhap ten website: " 
read website
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

dataname=`cat /home/$website/public_html/wp-config.php | grep DB_NAME | cut -d \' -f 4`
randomwp=`date |md5sum |cut -c '1-18'`
echo "$website" > /tmp/lemp-tensitephuchoi
echo "$dataname" > /tmp/lemp-tendatabasephuchoi
date -r /var/lib/mysql/$dataname +%H%M%S> /tmp/lemp1
randomcode=`date |md5sum |cut -c '1-12'`
if [ ! -f /home/$mainsite/private_html/backup/$dataname/*.sql.gz ]; then
     
   if [ -f /home/$website/public_html/lemp-DATABASE.tar.gz ]; then
   /etc/lemp/menu/lemp-phuc-hoi-database-lemp-database-tar-gz-wordpress.sh
   elif [ -f /home/$website/public_html/lemp-DATABASE.sql.gz ]; then
   /etc/lemp/menu/lemp-phuc-hoi-database-lemp-database-sql-gz-wordpress.sh
   elif [ -f /home/$website/public_html/lemp-DATABASE.zip ]; then
   /etc/lemp/menu/lemp-phuc-hoi-database-lemp-database-zip-wordpress.sh
   elif [ -f /home/$website/public_html/lemp-DATABASE.sql ]; then
   /etc/lemp/menu/lemp-phuc-hoi-database-lemp-database-sql-wordpress.sh
   else
	clear
	echo "========================================================================="
	echo "CACH PHUC HOI DATABASE"
	echo "========================================================================="
	echo "Dinh dang backup lemp ho tro phuc hoi: .SQL, .ZIP, .SQL.GZ va .TAR.GZ"
	echo "-------------------------------------------------------------------------"
	echo "Tuy theo dinh dang file backup ma ban thuc hien:"
	echo "-------------------------------------------------------------------------"
	echo "Dinh dang .SQL    => Doi ten file backup thanh lemp-DATABASE.sql"
	echo "-------------------------------------------------------------------------"
	echo "Dinh dang .ZIP    => Doi ten file backup thanh lemp-DATABASE.zip"
	echo "-------------------------------------------------------------------------"
	echo "Dinh dang .SQL.GZ => Doi ten backup thanh lemp-DATABASE.sql.gz"
	echo "-------------------------------------------------------------------------"
	echo "Dinh dang .TAR.GZ => Doi ten backup thanh lemp-DATABASE.tar.gz"
	echo "-------------------------------------------------------------------------"
	echo "Sau do upload len:"
	echo "-------------------------------------------------------------------------"
	echo "/home/$website/public_html/"
	echo "========================================================================="
	read -p "Khi upload hoan thanh. Nhan [Enter] de phuc hoi..."
	echo "-------------------------------------------------------------------------"
	echo "LEMP dang tim kiem file backup .... "
	echo "-------------------------------------------------------------------------"
	sleep 4
	if [ -f /home/$website/public_html/lemp-DATABASE.tar.gz ]; then
   /etc/lemp/menu/lemp-phuc-hoi-database-lemp-database-tar-gz-wordpress.sh
    elif [ -f /home/$website/public_html/lemp-DATABASE.sql.gz ]; then
   /etc/lemp/menu/lemp-phuc-hoi-database-lemp-database-sql-gz-wordpress.sh
    elif [ -f /home/$website/public_html/lemp-DATABASE.zip ]; then
   /etc/lemp/menu/lemp-phuc-hoi-database-lemp-database-zip-wordpress.sh
    elif [ -f /home/$website/public_html/lemp-DATABASE.sql ]; then
   /etc/lemp/menu/lemp-phuc-hoi-database-lemp-database-sql-wordpress.sh
    else
	clear
		echo "========================================================================="
		echo "Khong tim thay file backup cua database $dataname !"
		echo "-------------------------------------------------------------------------"
		echo "Hay upload file Backup len server roi thu lai"
		/etc/lemp/menu/lemp-wordpress-tools-menu.sh
		exit
		fi
		fi
else
find /home/$mainsite/private_html/backup/$dataname -name '*.sql.gz' -type f -exec basename {} \;  > /tmp/backupname
if [ ! "$(cat /tmp/backupname | wc -l)" == "1" ]; then
clear
echo "========================================================================="
echo "Co nhieu hon 1 file backup dinh dang SQL.GZ trong: "
echo "-------------------------------------------------------------------------"
echo "/home/$mainsite/private_html/backup/$dataname"
echo "-------------------------------------------------------------------------"
echo "Ban vui long chi de mot file .SQL.GZ duy nhat trong thu muc nay"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
filename=`cat /tmp/backupname`
rm -rf /tmp/backupname
echo "========================================================================="
echo "Tim thay file backup cua $dataname: $filename"
echo "-------------------------------------------------------------------------"
echo "File backup duoc tao vao: $(date -r /home/$mainsite/private_html/backup/$dataname/$filename +%H:%M/%F)"
echo "========================================================================="
prompt="Nhap lua chon cua ban: "
options=( "Phuc hoi database tu file backup $filename" "Phuc hoi database tu file backup khac" "Huy bo")
printf "CHON CACH PHUC HOI DATABASE\n"
printf "=========================================================================\n"
PS3="$prompt"
select opt in "${options[@]}"; do 

    case "$REPLY" in
    1) luachonphuchoi="phuchoitufilebackup"; break;;
    2) luachonphuchoi="uploadsaudophuchoi"; break;;
    3) luachonphuchoi="cancel"; break;;
    *) echo "Ban nhap sai, vui long nhap theo danh sach";continue;;
    esac  
done
###################################
#phuchoitufilebackup
###################################
if [ "$luachonphuchoi" = "phuchoitufilebackup" ]; then
echo "--------------------------------------------------------------------------"
echo "Please wait ...."
echo "--------------------------------------------------------------------------"
echo "LEMP dang Restore $dataname.........."
sleep 3
gunzip < /home/$mainsite/private_html/backup/$dataname/$filename | mariadb -u root -p$mariadbpass $dataname
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
	
	clear
	echo "========================================================================="
	echo "Phuc hoi database $dataname thanh cong !"
	/etc/lemp/menu/lemp-wordpress-tools-menu.sh
	fi
###################################
#Upload file backup len va Restore tu file nay
###################################
elif [ "$luachonphuchoi" = "uploadsaudophuchoi" ]; then
randomcode=`date |md5sum |cut -c '1-12'`
	if [ -f /home/$website/public_html/lemp-DATABASE.tar.gz ]; then
   /etc/lemp/menu/lemp-phuc-hoi-database-lemp-database-tar-gz-wordpress.sh
    elif [ -f /home/$website/public_html/lemp-DATABASE.sql.gz ]; then
   /etc/lemp/menu/lemp-phuc-hoi-database-lemp-database-sql-gz-wordpress.sh
    elif [ -f /home/$website/public_html/lemp-DATABASE.zip ]; then
   /etc/lemp/menu/lemp-phuc-hoi-database-lemp-database-zip-wordpress.sh
    elif [ -f /home/$website/public_html/lemp-DATABASE.sql ]; then
   /etc/lemp/menu/lemp-phuc-hoi-database-lemp-database-sql-wordpress.sh
    else
	clear
	echo "========================================================================="
	echo "CACH PHUC HOI DATABASE"
	echo "========================================================================="
	echo "Dinh dang backup lemp ho tro phuc hoi: .SQL, .ZIP, .SQL.GZ va .TAR.GZ"
	echo "-------------------------------------------------------------------------"
	echo "Tuy theo dinh dang file backup ma ban thuc hien:"
	echo "-------------------------------------------------------------------------"
	echo "Dinh dang .SQL    => Doi ten file backup thanh lemp-DATABASE.sql"
	echo "-------------------------------------------------------------------------"
	echo "Dinh dang .ZIP    => Doi ten file backup thanh lemp-DATABASE.zip"
	echo "-------------------------------------------------------------------------"
	echo "Dinh dang .SQL.GZ => Doi ten backup thanh lemp-DATABASE.sql.gz"
	echo "-------------------------------------------------------------------------"
	echo "Dinh dang .TAR.GZ => Doi ten backup thanh lemp-DATABASE.tar.gz"
	echo "-------------------------------------------------------------------------"
	echo "Sau do upload len:"
	echo "-------------------------------------------------------------------------"
	echo "/home/$website/public_html/"
	echo "========================================================================="
	read -p "Khi upload hoan thanh. Nhan [Enter] de phuc hoi..."
	echo "-------------------------------------------------------------------------"
	echo "LEMP dang tim kiem file backup .... "
	echo "-------------------------------------------------------------------------"
	sleep 4
	if [ -f /home/$website/public_html/lemp-DATABASE.tar.gz ]; then
   /etc/lemp/menu/lemp-phuc-hoi-database-lemp-database-tar-gz-wordpress.sh
    elif [ -f /home/$website/public_html/lemp-DATABASE.sql.gz ]; then
   /etc/lemp/menu/lemp-phuc-hoi-database-lemp-database-sql-gz-wordpress.sh
    elif [ -f /home/$website/public_html/lemp-DATABASE.zip ]; then
   /etc/lemp/menu/lemp-phuc-hoi-database-lemp-database-zip-wordpress.sh
    elif [ -f /home/$website/public_html/lemp-DATABASE.sql ]; then
   /etc/lemp/menu/lemp-phuc-hoi-database-lemp-database-sql-wordpress.sh
    else
	clear
		echo "========================================================================="
		echo "Khong tim thay file backup cua database $dataname !"
		echo "-------------------------------------------------------------------------"
		echo "Hay upload file Backup len server roi thu lai"
		/etc/lemp/menu/lemp-wordpress-tools-menu.sh
		exit
		fi
fi
###################################
#Huy bo phuchoi
###################################
else 
clear && /etc/lemp/menu/lemp-wordpress-tools-menu.sh
fi
fi
