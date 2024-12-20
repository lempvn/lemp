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

echo "========================================================================="
echo "=============================== LUU Y! ==================================="
echo "========================================================================="
echo "Su dung chuc nang nay se doi mat khau tai khoan Root cua VPS Backup"
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon thay mat khau tai khoan root VPS backup ? [y/N] " response
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
echo -n "Nhap password moi [ENTER]: " 
read PASS1
if [ "$PASS1" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai!"
/etc/lemp/menu/backup/lemp-rsync-backup-vps-menu.sh
exit
fi
echo "-------------------------------------------------------------------------"
echo -n "Nhap lai password [ENTER]: " 
read PASS2
if [ "$PASS1" != "$PASS2" ]; then
clear
echo "========================================================================="
echo "Mat khau ban nhap hai lan khong giong nhau !"
echo "-------------------------------------------------------------------------"
echo "Ban hay lam lai"
/etc/lemp/menu/backup/lemp-rsync-backup-vps-menu.sh
exit
fi
echo "-------------------------------------------------------------------------"
ipvpsbackup=$(grep "ipaddress" /etc/lemp/vps_backup_rsync.info | awk '{print $3}')
cat > "/tmp/change-password-user-root-vps-backup" <<END
if [ -f /etc/lsb-release ]; then
echo "root:$PASS1" | chpasswd
elif [ -f /etc/debian_version ]; then
echo "root:$PASS1" | chpasswd
elif [ -f /etc/redhat-release ]; then
echo "$PASS1" | passwd --stdin root
else
echo "$PASS1" | passwd --stdin root
fi
END
rsync -avzq -e ssh /tmp/change-password-user-root-vps-backup root@$ipvpsbackup:/tmp/change-password-user-root-vps-backup
ssh root@$ipvpsbackup chmod +x /tmp/change-password-user-root-vps-backup
ssh root@$ipvpsbackup /tmp/change-password-user-root-vps-backup
ssh root@$ipvpsbackup rm -rf /tmp/change-password-user-root-vps-backup
rm -rf /tmp/change-password-user-root-vps-backup
if [ -f ~/.ssh/known_hosts ]; then
if [ ! "$(grep "$ipvpsbackup" ~/.ssh/known_hosts)" == "" ]; then
echo "-------------------------------------------------------------------------"
echo "sed -i '/$ipvpsbackup/d' ~/.ssh/known_hosts" > /tmp/knownhost_sedit
chmod +x /tmp/knownhost_sedit
/tmp/knownhost_sedit
rm -rf /tmp/knownhost_sedit
fi
fi
cat > "/tmp/rsync_ketnoi" <<END
sshpass -p '$PASS1' ssh-copy-id -i ~/.ssh/id_rsa.pub $ipvpsbackup > /tmp/abc
END
chmod +x /tmp/rsync_ketnoi
/tmp/rsync_ketnoi
rm -rf /tmp/rsync_ketnoi
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
clear
echo "========================================================================="
echo "Thay mat khau cho tai khoan root cua VPS backup thanh cong"
echo "-------------------------------------------------------------------------"
echo "Mat khau moi la: $PASS1"
echo "-------------------------------------------------------------------------"
echo "Neu dang nhap VPS tren may tinh that bai, truoc khi dang nhap"
echo "-------------------------------------------------------------------------"
echo "ban thu chay lenh sau:  ssh-keygen -R $ipvpsbackup"
/etc/lemp/menu/backup/lemp-rsync-backup-vps-menu.sh
exit
    ;;
*)
clear
echo "========================================================================="
echo "You cancel change password for root user in vps backup!"
  /etc/lemp/menu/backup/lemp-rsync-backup-vps-menu.sh
;;
esac

