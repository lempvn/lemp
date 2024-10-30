#!/bin/bash
if [ -f /etc/lemp/lemp_backup_VPS_by_rsync ]; then
	if [ ! -f /etc/cron.d/lemp.rsync.cron ]; then
	rm -rf /etc/lemp/lemp_backup_VPS_by_rsync
	fi
fi
if [ -f /etc/cron.d/lemp.rsync.cron ]; then
	if [ ! -f /etc/lemp/lemp_backup_VPS_by_rsync ]; then
	rm -rf /etc/cron.d/lemp.rsync.cron
	fi
fi
options=("Ket Noi VPS Backup" "Cau Hinh Thoi Gian Dong Bo" "Backup VPS Ngay Lap Tuc" "Thay Mat Khau User Root" "Disable Sync To VPS Backup")
prompt="Nhap lua chon cua ban (0-Thoat): "
#prompt="Type in your choice (7-Exit):"
printf "=========================================================================\n"
printf "               LEMP - Quan Ly VPS/Server by LEMP.VN \n"
printf "=========================================================================\n"
printf "                          Quan Ly VPS Backup \n"
printf "=========================================================================\n"
if [ -f /etc/lemp/vps_backup_rsync.info ]; then
if [ ! "$(grep "thanhcong" /etc/lemp/vps_backup_rsync.info | awk '{print $3}')" == "" ]; then
printf "            VPS Backup: Config Finished | IP: $(grep "ipaddress" /etc/lemp/vps_backup_rsync.info | awk '{print $3}') \n"
printf "=========================================================================\n"
fi
fi
PS3="$prompt"
select opt in "${options[@]}" ; do 

    case "$REPLY" in
    1) /etc/lemp/menu/backup/lemp-rsync-ket-noi-vps-backup.sh;;
    2) /etc/lemp/menu/backup/lemp-rsync-cau-hinh-thu-muc-sao-luu.sh;;
    3) /etc/lemp/menu/backup/lemp-rsync-sync-toi-vps-backup-ngay.sh;;
    #4) /etc/lemp/menu/backup/lemp-rsync-cai-dat-csf-firewall-cho-vps-backup.sh;;
    4) /etc/lemp/menu/backup/lemp-rsync-doi-mat-khau-tai-khoan-root-vps-backup.sh;;
    5) /etc/lemp/menu/backup/lemp-rsync-ngat-ket-noi-vps-backup.sh;;
    6) clear && lemp;;
    0) clear && lemp;;
        *) echo "Ban nhap sai, vui long nhap so thu tu trong danh sach";continue;;
      #  *) echo "You typed wrong, Please type in the ordinal number on the list";continue;;

    esac

done






