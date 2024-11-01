#!/bin/bash 
. /home/lemp.conf
if [ -f /etc/lemp/vps_backup_rsync.info ]; then
if [ ! "$(grep "thanhcong" /etc/lemp/vps_backup_rsync.info | awk '{print $3}')" == "" ]; then
clear
echo "========================================================================="
echo "Ban da hoan thanh cau hinh ket noi server hien tai voi VPS backup"
echo "-------------------------------------------------------------------------"
echo "VPS Backup co dia chi IP: $(grep "ipaddress" /etc/lemp/vps_backup_rsync.info | awk '{print $3}')"
/etc/lemp/menu/backup/lemp-rsync-backup-vps-menu.sh
exit
fi
fi
echo "========================================================================="
echo "Su dung chuc nang nay de Ket Noi server hien tai voi VPS Backup"
echo "-------------------------------------------------------------------------"
echo "Sau khi ket noi thanh cong, su dung chuc nang [Cau Hinh Thoi Gian Dong Bo]"
echo "-------------------------------------------------------------------------"
echo "de thiet lap thoi gian dong bo du lieu giua server hien tai va VPS backup"
echo "-------------------------------------------------------------------------"
echo "Thong tin VPS Backup can nhap: dia chi IP va Mat khau tai khoan Root"
echo "-------------------------------------------------------------------------"
echo -n "Nhap IP VPS Backup [ENTER]: " 
read ipvpsbackup
if [ "$ipvpsbackup" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai."
/etc/lemp/menu/backup/lemp-rsync-backup-vps-menu.sh
exit
fi

if [ ! "$(ping -c 1 $ipvpsbackup | tail -n +1 | head -1 | awk 'NR==1 {print $1}')" == "PING" ]; then
clear
echo "========================================================================="
echo "$ipvpsbackup khong phai la dia chi IP ! "
#echo "$ipvpsbackup is not a valid IP/CIDR ! "
echo "-------------------------------------------------------------------------"
echo "Vui long nhap lai"
#echo "Please try again."
/etc/lemp/menu/backup/lemp-rsync-backup-vps-menu.sh
exit
fi
echo "-------------------------------------------------------------------------"
echo -n "Nhap password tai khoan root [ENTER]: "
read passrootbackupvps
if [ "$passrootbackupvps" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai."
/etc/lemp/menu/backup/lemp-rsync-backup-vps-menu.sh
exit
fi
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
echo "-------------------------------------------------------------------------"
sshpass -p '$passrootbackupvps' ssh-copy-id -i ~/.ssh/id_rsa.pub $ipvpsbackup > /tmp/abc
END
chmod +x /tmp/rsync_ketnoi
/tmp/rsync_ketnoi
rm -rf /tmp/rsync_ketnoi
rm -rf /tmp/abc
checkconnect=$(ssh -o BatchMode=yes -o ConnectTimeout=9 root@$ipvpsbackup echo connected 2>&1)
if [[ ! $checkconnect == connected ]] ; then
clear
echo "========================================================================="
echo "Ket noi that bai"
echo "-------------------------------------------------------------------------"
echo "Ban vui long kiem tra lai thong tin VPS Backup"
/etc/lemp/menu/backup/lemp-rsync-backup-vps-menu.sh
exit
fi
cat > "/etc/lemp/vps_backup_rsync.info" <<END
ipaddress = $ipvpsbackup
ketnoistatus = thanhcong
END
clear
echo "========================================================================="
echo "Ket noi toi VPS backup $ipvpsbackup thanh cong ! "
echo "-------------------------------------------------------------------------"
echo "Bay gio ban co the cau hinh thoi gian dong bo cho Server"
/etc/lemp/menu/backup/lemp-rsync-backup-vps-menu.sh
exit


