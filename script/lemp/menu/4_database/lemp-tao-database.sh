#!/bin/bash

. /home/lemp.conf
echo "========================================================================="
echo "Su dung chuc nang nay de tao (them) database moi tren server"
echo "-------------------------------------------------------------------------"
echo "Ten Database va mat khau chi duoc toi da 16 ky tu."
echo "-------------------------------------------------------------------------"
echo -n "Nhap ten database [ENTER]: " 
read dataname
dataname=`echo $dataname | tr '[A-Z]' '[a-z]'`
if [ "$dataname" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai !"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
exit
fi
if [[ $dataname =~ ^[0-9]+$ ]]; then
clear
echo "========================================================================="
echo "Ban khong the su dung toan chu so de dat ten database."
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai  !"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
exit
fi

if [[ ${#dataname} -ge 16 ]]; then
clear
echo "========================================================================="
echo "Ten database toi da la 16 ky tu"
echo "-------------------------------------------------------------------------"
echo "Ban vui long nhap lai !"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
exit
fi

kiemtradata="^[a-zA-Z0-9_][-a-zA-Z0-9_]{0,61}[a-zA-Z0-9_]$";
if [[ ! "$dataname" =~ $kiemtradata ]]; then
	
clear
echo "========================================================================="
echo "Tao database $dataname that bai!"
echo "-------------------------------------------------------------------------"
echo "Ban chi duoc su dung so, chu cai va ki tu: _  . Ban vui long thu lai  !"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
exit
fi 

if [[ ! ${#dataname} -ge 5 ]]; then
clear
echo "========================================================================="
echo "Tao $dataname that bai ! Ten cua database toi thieu phai co 5 ki tu."
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai  !"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
exit
fi  
if [ -f /var/lib/mysql/$dataname/db.opt ]; then
clear
echo "========================================================================="
echo "Data $dataname da ton tai tren server."
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
exit
fi
    cat > "/tmp/config.temp" <<END
CREATE DATABASE $dataname COLLATE utf8_general_ci;
END

mariadb -u root -p$mariadbpass < /tmp/config.temp
rm -f /tmp/config.temp
if [ ! -f /var/lib/mysql/$dataname/db.opt ]; then
clear
echo "========================================================================="
echo "Tao Data $dataname that bai."
echo "-------------------------------------------------------------------------"
echo "Ban vui long kiem tra lai dich vu MySQL"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
exit
fi
echo "-------------------------------------------------------------------------"
echo "Tao data $dataname thanh cong !"
echo "-------------------------------------------------------------------------"
echo "Default Charset is utf8 !"
echo "========================================================================="
read -r -p "Ban muon tao user moi cho $dataname ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "-------------------------------------------------------------------------"
	echo -n "Type username [ENTER]: " 
	read username
	username=`echo $username | tr '[A-Z]' '[a-z]' | cut -c1-16`
	if [ "$username" = "" ]; then
		username="$dataname"
		echo "-------------------------------------------------------------------------"
		echo "Ban nhap sai, chung toi se su dung username la: $dataname"
	fi
	echo "-------------------------------------------------------------------------"
	echo -n "Type password [ENTER]: " 
	read password
	if ! [[ ${#password} -ge 6 && ${#password} -le 16  ]] ; then 
	
	 cat > "/tmp/config.temp" <<END
drop database $dataname;
END
mariadb -u root -p$mariadbpass < /tmp/config.temp
rm -rf /tmp/config.temp
clear
echo "========================================================================="
echo "Tao Database $dataname that bai!"
echo "-------------------------------------------------------------------------"
echo "Mat khau ban su dung phai tu 6 den 16 ky tu."
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai  !"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
exit
fi  
echo "-------------------------------------------------------------------------"
	echo "Please wait....";sleep 1
    cat > "/tmp/config.temp" <<END
CREATE USER '$username'@'localhost' IDENTIFIED BY '$password';
END

	mariadb -u root -p$mariadbpass < /tmp/config.temp
	rm -rf /tmp/config.temp

    cat > "/tmp/config.temp" <<END
GRANT ALL PRIVILEGES ON $dataname . * TO '$username'@'localhost';
END
	mariadb -u root -p$mariadbpass < /tmp/config.temp
	rm -rf /tmp/config.temp

    cat > "/tmp/config.temp" <<END
FLUSH PRIVILEGES;
END
	mariadb -u root -p$mariadbpass < /tmp/config.temp
	rm -rf /tmp/config.temp
	
echo "=========================================================================" >> /home/DBinfo.txt
echo "Database: $dataname - Duoc tao vao: $(date +%d/%m/%Y)" >> /home/DBinfo.txt
echo "=========================================================================" >> /home/DBinfo.txt
echo "Data name: $dataname" >> /home/DBinfo.txt
echo "Username: $username" >> /home/DBinfo.txt
echo "password: $password" >> /home/DBinfo.txt
echo "" >> /home/DBinfo.txt
if [ ! -f /var/lib/mysql/$dataname/db.opt ]; then
clear
echo "========================================================================="
echo "Tao database $dataname that bai !"
echo "-------------------------------------------------------------------------"
echo "Ban vui long kiem tra lai"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
exit
fi
clear
echo "========================================================================="
echo "Tao Database $dataname thanh cong. Thong tin Database: "
echo "-------------------------------------------------------------------------"
echo "Database: $dataname"
echo "-------------------------------------------------------------------------" 
echo "Username: $username | Password: $password" 
echo "-------------------------------------------------------------------------"
echo "Thong tin database da duoc luu vao: /home/DBinfo.txt"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
            ;;
    *)

echo "=========================================================================" >> /home/DBinfo.txt
echo "Database: $dataname - Duoc tao vao: $(date +%H:%M-%d/%m/%Y)" >> /home/DBinfo.txt
echo "=========================================================================" >> /home/DBinfo.txt
echo "Databasae: $dataname" >> /home/DBinfo.txt
echo "Username: root" >> /home/DBinfo.txt
echo "password: $mariadbpass" >> /home/DBinfo.txt
echo "" >> /home/DBinfo.txt

	echo ""
        ;;
esac
if [ ! -f /var/lib/mysql/$dataname/db.opt ]; then
clear
echo "========================================================================="
echo "Tao database $dataname that bai !"
echo "-------------------------------------------------------------------------"
echo "Ban vui long kiem tra lai"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
exit
fi
clear
echo "========================================================================="
echo "Tao Database $dataname thanh cong. Thong tin Database: "
echo "-------------------------------------------------------------------------"
echo "Data Name: $dataname"
echo "-------------------------------------------------------------------------" 
echo "Username: root | Password: $mariadbpass" 
echo "-------------------------------------------------------------------------"
echo "Thong tin database da duoc luu vao: /home/DBinfo.txt"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
exit
fi
