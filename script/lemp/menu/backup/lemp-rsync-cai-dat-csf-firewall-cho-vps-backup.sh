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
csfstatus=$(grep "CSF-Firewall" /etc/lemp/vps_backup_rsync.info | awk '{print $3}')
if [ "$csfstatus" == "installed" ]; then
clear
echo "========================================================================="
echo "VPS backup da duoc cai dat CSF FireWall"
/etc/lemp/menu/backup/lemp-rsync-backup-vps-menu.sh
exit
fi
echo "========================================================================="
echo "Su dung chuc nang nay de cai dat CSF Firewall cho VPS Backup"
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon cai dat CSF Firewall cho VPS backup ? [y/N] " response
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

if [ "$(grep "Createfolder" /etc/lemp/vps_backup_rsync.info | awk '{print $3}')" == "" ]; then
echo "-------------------------------------------------------------------------"
echo "Cai dat rsync and wget cho VPS Backup "
echo "-------------------------------------------------------------------------"
ssh root@$ipvpsbackup apt-get -y -q install rsync wget tar
ssh root@$ipvpsbackup yum -y -q install rsync wget tar
echo "Createfolder = thanhcong" >> /etc/lemp/vps_backup_rsync.info
fi

cat > "/tmp/config-csf-firewall1.sh" <<END
echo "$serverip" >> /etc/csf/csf.allow
echo "$serverip" >> /etc/csf/csf.ignore
END
rsync -avzq -e ssh /etc/lemp/menu/backup/Setup-csf-firewall-vps-backup-rsync root@$ipvpsbackup:/tmp/Setup-csf-firewall-vps-backup-rsync
rsync -avzq -e ssh /tmp/config-csf-firewall1.sh root@$ipvpsbackup:/tmp/config-csf-firewall1.sh
ssh root@$ipvpsbackup chmod +x /tmp/Setup-csf-firewall-vps-backup-rsync
ssh root@$ipvpsbackup chmod +x /tmp/config-csf-firewall1.sh
ssh root@$ipvpsbackup /tmp/Setup-csf-firewall-vps-backup-rsync
ssh root@$ipvpsbackup /tmp/config-csf-firewall1.sh
who am i| awk '{ print $5}' | sed 's/(//'| sed 's/)//' > /tmp/checkip
checksize=$(du -sb /tmp/checkip | awk 'NR==1 {print $1}')
if [ $checksize -gt 8 ]; then
checkip=$(cat /tmp/checkip)
cat > "/tmp/config-csf-firewall2.sh" <<END
echo "$checkip" >> /etc/csf/csf.ignore
echo "$checkip" >> /etc/csf/csf.allow
END
rsync -avzq -e ssh /tmp/config-csf-firewall2.sh root@$ipvpsbackup:/tmp/config-csf-firewall2.sh
ssh root@$ipvpsbackup chmod +x /tmp/config-csf-firewall2.sh
ssh root@$ipvpsbackup /tmp/config-csf-firewall2.sh
fi
ssh root@$ipvpsbackup csf -r
ssh root@$ipvpsbackup rm -rf /tmp/Setup-csf-firewall-vps-backup-rsync
ssh root@$ipvpsbackup rm -rf /tmp/config-csf-firewall1.sh
ssh root@$ipvpsbackup rm -rf /tmp/config-csf-firewall2.sh
rm -rf /tmp/checkip
echo "CSF-Firewall = installed" >> /etc/lemp/vps_backup_rsync.info
clear
echo "========================================================================="
echo "Cai dat va cau hinh CSF Firewall Cho VPS Backup thanh cong "
/etc/lemp/menu/backup/lemp-rsync-backup-vps-menu.sh

;;
*)
rm -rf /etc/cron.d/lemp.rsync.cron
rm -rf /etc/lemp/lemp_backup_VPS_by_rsync
clear
echo "========================================================================="
echo "Ban huy cai dat CSF Firewall cho VPS backup !"
  /etc/lemp/menu/backup/lemp-rsync-backup-vps-menu.sh
  exit
;;
esac
exit

