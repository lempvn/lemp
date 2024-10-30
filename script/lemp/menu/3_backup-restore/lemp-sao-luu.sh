#!/bin/bash
. /home/lemp.conf
if [ ! -f /usr/local/bin/htpasswd.py ]; then
cp -r /etc/lemp/menu/lemp-tao-mat-khau-bao-ve-folder.py /usr/local/bin/htpasswd.py
chmod 755 /usr/local/bin/htpasswd.py
fi
if [ ! -f /etc/lemp/pwprotect.default ]; then
echo "" > /etc/lemp/pwprotect.default
fi
if [ ! -f /etc/cron.d/lemp.code.cron ]; then
touch /etc/cron.d/lemp.code.cron
fi
if [ ! -d /home/$mainsite/private_html/backup ]; then
mkdir -p /home/$mainsite/private_html/backup
fi
find /home/$mainsite/private_html/backup/ -name "*.zip*" > /tmp/lemp_check_backup_code_size

numberfiles=$(cat /tmp/lemp_check_backup_code_size | wc -l)
if [ ! "$numberfiles" = "0" ]; then
backupcodesize=$(du -ch $(cat /tmp/lemp_check_backup_code_size) | tail -1 | cut -f 1)
else
backupcodesize=0KB
fi
rm -rf /tmp/*lemp*
prompt="Lua chon cua ban (0-Thoat):"
options=("Backup Code 1 Website" "Backup Code All Website" "Tu Dong Backup Website" "Phuc Hoi Website" "Lay Link File Backup" "Xoa Tat Ca File Backup")
printf "=========================================================================\n"
printf "                LEMP - Quan Ly VPS/Server by LEMP.VN \n"
printf "=========================================================================\n"
printf "                         Sao Luu & Phuc Hoi Code\n"
printf "=========================================================================\n"
printf "                       Total Backup Files Size: $backupcodesize \n"
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

    1 ) /etc/lemp/menu/3_backup-restore/lemp-sao-luu-code.sh;;
    2 ) /etc/lemp/menu/3_backup-restore/lemp-lan-luot-sao-luu-het-tat-ca-website.sh;;
    #3 ) /etc/lemp/menu/3_backup-restore/lemp-sao-luu-home.sh;; "Backup Folder Home" 
    3 ) /etc/lemp/menu/3_backup-restore/lemp-tu-dong-sao-luu-code-menu.sh;;
    4 ) /etc/lemp/menu/3_backup-restore/lemp-phuc-hoi-website.sh;;
    5 ) /etc/lemp/menu/3_backup-restore/lemp-lay-link-sao-luu-website-backup-menu.sh;;
    #6 ) /etc/lemp/menu/3_backup-restore/lemp-link-tai-sao-luu-tat-ca-cac-site;; "Link File Backup Home" 
    6 ) /etc/lemp/menu/3_backup-restore/lemp-xoa-toan-bo-backup-website.sh;;
    7 ) clear && lemp;;
    0) clear && lemp;;
    
    *) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu !";continue;;

    esac

done

