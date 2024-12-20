#!/bin/bash
. /home/lemp.conf
if [ ! -f /usr/local/bin/htpasswd.py ]; then
cp -r /etc/lemp/menu/4_database/lemp-tao-mat-khau-bao-ve-folder.py /usr/local/bin/htpasswd.py
chmod 755 /usr/local/bin/htpasswd.py
fi
if [ ! -f /etc/lemp/pwprotect.default ]; then
echo "" > /etc/lemp/pwprotect.default
fi
if [ ! -f /etc/cron.d/lemp.db.cron ]; then
touch /etc/cron.d/lemp.db.cron
fi
if [ ! -d /home/$mainsite/private_html/backup ]; then
mkdir -p /home/$mainsite/private_html/backup
fi
if [ -f /var/lib/mysql/lempCheckDB/db.opt ]; then
rm -rf /var/lib/mysql/lempCheckDB
fi
find /home/$mainsite/private_html/backup/ -name "*.tar.gz*" > /tmp/lemp_check_backup_database_size
find /home/$mainsite/private_html/backup/ -name "*.sql.gz*" >> /tmp/lemp_check_backup_database_size

numberfiles=$(cat /tmp/lemp_check_backup_database_size | wc -l)
if [ ! "$numberfiles" = "0" ]; then
backupdatabasesize=$(du -ch $(cat /tmp/lemp_check_backup_database_size) | tail -1 | cut -f 1)
else
backupdatabasesize=0KB
fi
ls -l /var/lib/mysql | grep "^d" | awk -F" " '{print $9}' | grep -Ev "(Database|information_schema|mysql|performance_schema|lempCheckDB)" > /tmp/lemp_check_db
listdbnumber=`cat /tmp/lemp_check_db`
rm -rf /tmp/lemp_listdbf
for database in $listdbnumber
do
echo "/var/lib/mysql/$database" >> /tmp/lemp_listdbf
done
if [ -f /tmp/lemp_listdbf ]; then
numberdb=$(cat /tmp/lemp_listdbf | wc -l)
	if [ ! "$numberdb" = "0" ]; then
	databasesize=$(du -ch $(cat /tmp/lemp_listdbf) | tail -1 | cut -f 1)
	else
	databasesize=0KB
	fi
else
databasesize=0KB
fi
rm -rf /tmp/*lemp*
prompt="Lua chon cua ban (0-Thoat):"
options=("Tao Database" "Xoa Database" "Backup 1 Database" "Backup Tat Ca Database" "Auto Backup Database" "Phuc Hoi (Restore) Database" "Auto re-Start MySQL Server" "Xem Mat Khau User Root MySQL" "Thay Doi Pass User Root MySQL" "Re-config MySQL" "Lay Link File Backup" "Xoa Tat Ca File Backup" "Danh Sach Database")
printf "=========================================================================\n"
printf "                LEMP - Quan Ly VPS/Server by LEMP.VN \n"
printf "=========================================================================\n"
printf "                            Quan ly Database                 \n"
printf "=========================================================================\n"
printf "        Total Databases Size: $databasesize | Total Backup Files Size: $backupdatabasesize \n"
printf "=========================================================================\n"
if [ "$(grep auth_basic_user_file /etc/nginx/conf.d/$mainsite.conf)" == "" ] ; then 
echo "Ban chua BAT tinh nang bao ve phpMyAdmin va cac file backup, ocp.php ..."
echo "-------------------------------------------------------------------------"
echo "Dung chuc nang [ BAT/TAT Bao Ve phpMyAdmin ] trong [ Quan Ly phpMyAdmin ]"
echo "-------------------------------------------------------------------------"
echo "de bat tinh nang nay."
echo "-------------------------------------------------------------------------"
echo "Thong bao nay se tu dong TAT sau khi ban hoan thanh cau hinh bao mat !"
echo "========================================================================="
echo""
fi
PS3="$prompt"
select opt in "${options[@]}" ; do 

    case "$REPLY" in   
    1) /etc/lemp/menu/4_database/lemp-tao-database.sh;;
    2) /etc/lemp/menu/4_database/lemp-xoa-database.sh;; 
    3 ) /etc/lemp/menu/4_database/lemp-sao-luu-data.sh;;
    4 ) /etc/lemp/menu/4_database/lemp-lan-luot-sao-luu-het-tat-ca-database.sh;;
    #4) clear && /etc/lemp/menu/4_database/lemp-sao-luu-phuc-hoi-tat-ca-database-menu;; "Full Backup & Restore Database" 
    5) /etc/lemp/menu/4_database/lemp-tu-dong-sao-luu-database-menu.sh;;
    6 ) /etc/lemp/menu/4_database/lemp-phuc-hoi-database-chon-dinh-dang.sh;;
    7) /etc/lemp/menu/tienich/befor-auto-start-mysql.sh;;
    8) /etc/lemp/menu/4_database/lemp-hien-mat-khau-root-mysql.sh;;
    9) /etc/lemp/menu/4_database/lemp-change-root-mysql-password.sh;;
    10) /etc/lemp/menu/4_database/lemp-re-config-database-cau-hinh-lai-mysql.sh;;
    11 ) /etc/lemp/menu/4_database/lemp-lay-link-sao-luu-database-backup-menu.sh;;
    12 ) /etc/lemp/menu/4_database/lemp-xoa-toan-bo-backup-database.sh;;
    13) /etc/lemp/menu/4_database/lemp-list-database-tren-vps-them-xoa-function.sh;; 
    14) clear && /bin/lemp;;
    0) clear && lemp;;
    *) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu !";continue;;

    esac

done

 
