#!/bin/sh
. /home/lemp.conf
echo "========================================================================="
echo "Database can phuc hoi phai ton tai tren he thong ! "
echo "========================================================================="
echo -n "Nhap ten Database can phuc hoi: " 
read dataname
if [ "$dataname" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap chinh xac!"
/etc/lemp/menu/lemp-sao-luu-phuc-hoi-database.sh
exit
fi
if [ ! -f /var/lib/mysql/$dataname/db.opt ]; then
clear
echo "========================================================================="
echo "Khong tim thay database $dataname tren server "
echo "-------------------------------------------------------------------------"
echo "Vui long thu lai !"
/etc/lemp/menu/lemp-sao-luu-phuc-hoi-database.sh
exit
fi
echo "-------------------------------------------------------------------------"
echo -n "NHap ten website can phuc hoi Database: "
read website
website=`echo $website | tr '[A-Z]' '[a-z]'`
if [ "$website" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai !"
/etc/lemp/menu/lemp-sao-luu-phuc-hoi-database.sh
exit
fi
kiemtradomain3="^([[:alnum:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)+[[:alpha:]]{2,14}$";
if [[ ! "$website" =~ $kiemtradomain3 ]]; then
	website=`echo $website | tr '[A-Z]' '[a-z]'`
clear
echo "========================================================================="
echo "$website co le khong phai domain !"
echo "-------------------------------------------------------------------------"
echo "Vui long thu lai !"
/etc/lemp/menu/lemp-sao-luu-phuc-hoi-database.sh
exit
fi
if [ ! -f /etc/nginx/conf.d/$website.conf ]; then
clear
echo "========================================================================="
echo "Khong tim thay website $website !"
echo "-------------------------------------------------------------------------"
echo "Vui long thu lai !"
/etc/lemp/menu/lemp-sao-luu-phuc-hoi-database.sh
exit
fi
date -r /var/lib/mysql/$dataname +%H%M%S> /tmp/lemp1
if [ ! -f /home/$mainsite/private_html/backup/$dataname/*.gz ]; then
randomcode=`date |md5sum |cut -c '1-13'`
	if [ -f /home/$website/public_html/lemp-DATABASE.tar.gz ]; then
	echo "-------------------------------------------------------------------------"
	echo "Tim thay file backup lemp-DATABASE.tar.gz"
	echo "-------------------------------------------------------------------------"
	echo "Chuan bi phuc hoi .... "
	echo "-------------------------------------------------------------------------"
	sleep 2
	gunzip < /home/$website/public_html/lemp-DATABASE.tar.gz | mysql -u root -p$mariadbpass $dataname
	date -r /var/lib/mysql/$dataname +%H%M%S> /tmp/lemp2
	check1=`cat /tmp/lemp1`
	check2=`cat /tmp/lemp2`
		if [ "$check1" == "$check2" ]; then
		rm -rf /tmp/lemp1
		rm -rf /tmp/lemp2
		clear
		echo "========================================================================="
		echo "Phuc hoi database $dataname that bai "
		echo "-------------------------------------------------------------------------"
		echo "Vui long kiem tra file backup va thu lai !"
		/etc/lemp/menu/lemp-sao-luu-phuc-hoi-database.sh
		else	
		rm -rf /tmp/lemp1
		rm -rf /tmp/lemp2
		mv /home/$website/public_html/lemp-DATABASE.tar.gz /home/$website/public_html/lemp-DATABASE.tar.gz.$randomcode
		clear
		echo "========================================================================="
		echo "Phuc hoi database $dataname thanh cong !"
		echo "-------------------------------------------------------------------------"
		echo "File backup duoc doi ten thanh lemp-DATABASE.tar.gz.$randomcode"
		/etc/lemp/menu/lemp-sao-luu-phuc-hoi-database.sh
		exit
		fi
	else
	clear
	echo "========================================================================="
	echo "CACH PHUC HOI DATABASE"
	echo "========================================================================="
	echo "Chuc nang nay ho tro phuc hoi database tu backup dinh dang TAR.GZ"
	echo "-------------------------------------------------------------------------"
	echo "Doi ten file backup thanh lemp-DATABASE.tar.gz sau do upload vao: "
	echo "-------------------------------------------------------------------------"
	echo "/home/$website/public_html/"
	echo "========================================================================="
	read -p "Khi upload hoan thanh. Nhan [Enter] de phuc hoi..."
	echo "-------------------------------------------------------------------------"
	echo "LEMP dang tim kiem file backup .... "
	echo "-------------------------------------------------------------------------"
	sleep 4
		if [ -f /home/$website/public_html/lemp-DATABASE.tar.gz ]; then
		echo "-------------------------------------------------------------------------"
	echo "Tim thay file backup lemp-DATABASE.tar.gz"
	echo "-------------------------------------------------------------------------"
	echo "Chuan bi phuc hoi .... "
	echo "-------------------------------------------------------------------------"
	sleep 2
	gunzip < /home/$website/public_html/lemp-DATABASE.tar.gz | mysql -u root -p$mariadbpass $dataname
	date -r /var/lib/mysql/$dataname +%H%M%S> /tmp/lemp2
	check1=`cat /tmp/lemp1`
	check2=`cat /tmp/lemp2`
		if [ "$check1" == "$check2" ]; then
		rm -rf /tmp/lemp1
		rm -rf /tmp/lemp2
		clear
		echo "========================================================================="
		echo "Phuc hoi database $dataname that bai "
		echo "-------------------------------------------------------------------------"
		echo "Vui long kiem tra file backup va thu lai !"
		/etc/lemp/menu/lemp-sao-luu-phuc-hoi-database.sh
		else	
		rm -rf /tmp/lemp1
		rm -rf /tmp/lemp2
		mv /home/$website/public_html/lemp-DATABASE.tar.gz /home/$website/public_html/lemp-DATABASE.tar.gz.$randomcode
		clear
		echo "========================================================================="
		echo "Phuc hoi database $dataname thanh cong !"
		echo "-------------------------------------------------------------------------"
		echo "File backup duoc doi ten thanh lemp-DATABASE.tar.gz.$randomcode"
		/etc/lemp/menu/lemp-sao-luu-phuc-hoi-database.sh
		exit
		fi
	else
	clear
		echo "========================================================================="
		echo "Khong tim thay website lemp-DATABASE.tar.gz !"
		echo "-------------------------------------------------------------------------"
		echo "Hay upload file Backup len server roi thu lai"
		/etc/lemp/menu/lemp-sao-luu-phuc-hoi-database.sh
		exit
		fi
		fi

else
find /home/$mainsite/private_html/backup/$dataname -type f -exec basename {} \;  > /tmp/backupname
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
    3) luachonphuchoi="cancle"; break;;
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
gunzip < /home/$mainsite/private_html/backup/$dataname/$filename | mysql -u root -p$mariadbpass $dataname
date -r /var/lib/mysql/$dataname +%H%M%S> /tmp/lemp2
check1=`cat /tmp/lemp1`
check2=`cat /tmp/lemp2`
	if [ "$check1" == "$check2" ]; then
	rm -rf /tmp/lemp1
	rm -rf /tmp/lemp2
	clear
	echo "========================================================================="
	echo "Phuc hoi database $dataname that bai "
	echo "-------------------------------------------------------------------------"
	echo "Vui long kiem tra file backup va thu lai !"
	/etc/lemp/menu/lemp-sao-luu-phuc-hoi-database.sh
	else	
	rm -rf /tmp/lemp1
	rm -rf /tmp/lemp2
	clear
	echo "========================================================================="
	echo "Phuc hoi database $dataname thanh cong !"
	/etc/lemp/menu/lemp-sao-luu-phuc-hoi-database.sh
	fi
###################################
#Upload file backup len va Restore tu file nay
###################################
elif [ "$luachonphuchoi" = "uploadsaudophuchoi" ]; then
randomcode=`date |md5sum |cut -c '1-18'`
	if [ -f /home/$website/public_html/lemp-DATABASE.tar.gz ]; then
	echo "-------------------------------------------------------------------------"
	echo "Tim thay file backup lemp-DATABASE.tar.gz"
	echo "-------------------------------------------------------------------------"
	echo "Chuan bi phuc hoi .... "
	echo "-------------------------------------------------------------------------"
	sleep 2
	gunzip < /home/$website/public_html/lemp-DATABASE.tar.gz | mysql -u root -p$mariadbpass $dataname
	date -r /var/lib/mysql/$dataname +%H%M%S> /tmp/lemp2
	check1=`cat /tmp/lemp1`
	check2=`cat /tmp/lemp2`
		if [ "$check1" == "$check2" ]; then
		rm -rf /tmp/lemp1
		rm -rf /tmp/lemp2
		clear
		echo "========================================================================="
		echo "Phuc hoi database $dataname that bai "
		echo "-------------------------------------------------------------------------"
		echo "Vui long kiem tra file backup va thu lai !"
		/etc/lemp/menu/lemp-sao-luu-phuc-hoi-database.sh
		else	
		rm -rf /tmp/lemp1
		rm -rf /tmp/lemp2
        mv /home/$website/public_html/lemp-DATABASE.tar.gz /home/$website/public_html/lemp-DATABASE.tar.gz.$randomcode
		clear
		echo "========================================================================="
		echo "Phuc hoi database $dataname thanh cong !"
		echo "-------------------------------------------------------------------------"
		echo "File backup duoc doi ten thanh lemp-DATABASE.tar.gz.$randomcode"
		/etc/lemp/menu/lemp-sao-luu-phuc-hoi-database.sh
		exit
		fi
		
	else
	clear
	echo "========================================================================="
	echo "CACH PHUC HOI DATABASE"
	echo "========================================================================="
	echo "Chuc nang nay ho tro phuc hoi database tu backup dinh dang TAR.GZ"
	echo "-------------------------------------------------------------------------"
	echo "Doi ten file backup thanh lemp-DATABASE.tar.gz sau do upload vao: "
	echo "-------------------------------------------------------------------------"
	echo "/home/$website/public_html/"
	echo "========================================================================="
	read -p "Khi upload hoan thanh. Nhan [Enter] de phuc hoi..."
	echo "-------------------------------------------------------------------------"
	echo "LEMP dang tim kiem file backup .... "
	echo "-------------------------------------------------------------------------"
	sleep 4
		if [ -f /home/$website/public_html/lemp-DATABASE.tar.gz ]; then
		echo "-------------------------------------------------------------------------"
	echo "Tim thay file backup lemp-DATABASE.tar.gz"
	echo "-------------------------------------------------------------------------"
	echo "Chuan bi phuc hoi .... "
	echo "-------------------------------------------------------------------------"
	sleep 2
	gunzip < /home/$website/public_html/lemp-DATABASE.tar.gz | mysql -u root -p$mariadbpass $dataname
	date -r /var/lib/mysql/$dataname +%H%M%S> /tmp/lemp2
	check1=`cat /tmp/lemp1`
	check2=`cat /tmp/lemp2`
		if [ "$check1" == "$check2" ]; then
		rm -rf /tmp/lemp1
		rm -rf /tmp/lemp2
		clear
		echo "========================================================================="
		echo "Phuc hoi database $dataname that bai "
		echo "-------------------------------------------------------------------------"
		echo "Vui long kiem tra file backup va thu lai !"
		/etc/lemp/menu/lemp-sao-luu-phuc-hoi-database.sh
		else	
		rm -rf /tmp/lemp1
		rm -rf /tmp/lemp2
		mv /home/$website/public_html/lemp-DATABASE.tar.gz /home/$website/public_html/lemp-DATABASE.tar.gz.$randomcode
		clear
		echo "========================================================================="
		echo "Phuc hoi database $dataname thanh cong !"
		echo "-------------------------------------------------------------------------"
		echo "File backup duoc doi ten thanh lemp-DATABASE.tar.gz.$randomcode"
		/etc/lemp/menu/lemp-sao-luu-phuc-hoi-database.sh
		exit
		fi

	else
	clear
		echo "========================================================================="
		echo "Khong tim thay lemp-DATABASE.tar.gz !"
		echo "-------------------------------------------------------------------------"
		echo "Hay upload file Backup len server roi thu lai"
		/etc/lemp/menu/lemp-sao-luu-phuc-hoi-database.sh
		exit
		fi
fi
###################################
#Huy bo phuchoi
###################################
else 
clear && /etc/lemp/menu/lemp-sao-luu-phuc-hoi-database.sh
fi
fi
