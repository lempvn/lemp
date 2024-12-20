#!/bin/bash 
. /home/lemp.conf
if [ ! -f /etc/lemp/vps_backup_rsync.info ]; then
clear
echo "========================================================================="
echo "Server hien tai chua duoc ket noi voi VPS backup"
echo "-------------------------------------------------------------------------"
echo "Ban khong can chay chuc nang nay."
/etc/lemp/menu/backup/lemp-rsync-backup-vps-menu.sh
exit
fi

ipvpsbackup=$(grep "ipaddress" /etc/lemp/vps_backup_rsync.info | awk '{print $3}')
echo "========================================================================="
echo "Su dung chuc nang nay Ngat Ket noi va Disable Auto backup toi VPS Backup"
echo "-------------------------------------------------------------------------"
echo "Sau khi ngat ket noi, du lieu tren VPS Backup duoc du nguyen"
echo "-------------------------------------------------------------------------"
echo "Neu muon tiep tuc backup, ban phai Ket Noi va config lai"
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon ngat ket noi toi VPS Backup ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "-------------------------------------------------------------------------"
    echo "Please wait ... "
    sleep 3
pkill rync
rm -rf ~/.ssh/id_rsa.pub
rm -rf ~/.ssh/id_rsa
echo "sed -i '/$ipvpsbackup/d' ~/.ssh/known_hosts" > /tmp/knownhost_sedit
chmod +x /tmp/knownhost_sedit
/tmp/knownhost_sedit
rm -rf /tmp/knownhost_sedit
rm -rf /etc/lemp/vps_backup_rsync.info
rm -rf /etc/lemp/lemp_backup_VPS_by_rsync 
rm -rf /etc/cron.d/lemp.rsync.cron  
systemctl restart cron.service
clear
echo "========================================================================="
echo "Ngat ket noi voi VPS backup thanh cong! "
  /etc/lemp/menu/backup/lemp-befor-rsync.sh
    ;;
*)
clear
echo "========================================================================="
echo "Ban huy disable backup by Rsync !"
  /etc/lemp/menu/backup/lemp-rsync-backup-vps-menu.sh
  exit
;;
esac
exit

