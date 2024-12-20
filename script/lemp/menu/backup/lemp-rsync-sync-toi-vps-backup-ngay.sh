#!/bin/bash 
. /home/lemp.conf
if [ ! -f /etc/lemp/vps_backup_rsync.info ]; then
clear
echo "========================================================================="
echo "Server hien tai chua duoc ket noi voi VPS backup"
echo "-------------------------------------------------------------------------"
echo "Ban vui long ket noi voi VPS backup truoc khi thuc hien thao tac nay."
/etc/lemp/menu/backup/lemp-rsync-backup-vps-menu.sh
exit
fi
if [ ! -f /etc/lemp/lemp_backup_VPS_by_rsync ]; then
clear
echo "========================================================================="
echo "Ban phai chay chuc nang [ Cau Hinh Thoi Gian Dong Bo] truoc khi su dung "
echo "-------------------------------------------------------------------------"
echo "Chuc nang nay."
/etc/lemp/menu/backup/lemp-rsync-backup-vps-menu.sh
exit
fi
echo "========================================================================="
echo "Su dung chuc nang nay de Sync du lieu toi VPS Backup ngay lap tuc"
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon Sync du lieu ngay ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
ipvpsbackup=$(grep "ipaddress" /etc/lemp/vps_backup_rsync.info | awk '{print $3}')
echo "-------------------------------------------------------------------------"
echo "Ket noi toi VPS Backup ... "
checkconnect=$(ssh -o BatchMode=yes -o ConnectTimeout=9 root@$ipvpsbackup echo connected 2>&1)
if [[ ! $checkconnect == connected ]] ; then
clear
echo "========================================================================="
echo "Ket noi toi VPS Backup that bai"
echo "-------------------------------------------------------------------------"
echo "LEMP khong the thuc hien chuc nang nay"
/etc/lemp/menu/backup/lemp-rsync-backup-vps-menu.sh
exit
fi
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
sleep 1
/etc/lemp/lemp_backup_VPS_by_rsync

clear
echo "========================================================================="
echo "Sync Data toi VPS Backup hoan thanh !"
echo "========================================================================="
echo "Thong tin File Backup nam trong thu muc /home cua VPS ban Backup toi!" 
echo "========================================================================="
/etc/lemp/menu/backup/lemp-rsync-backup-vps-menu.sh
exit
    ;;
*)
clear
echo "========================================================================="
echo "Ban huy Sync du lieu toi VPS backup ngay lap tuc !"
  /etc/lemp/menu/backup/lemp-rsync-backup-vps-menu.sh
  exit
;;
esac
exit

