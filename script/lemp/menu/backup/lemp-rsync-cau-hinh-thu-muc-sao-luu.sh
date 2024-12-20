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

if [ -f /etc/lemp/lemp_backup_VPS_by_rsync ]; then
minutesrsync=$(grep lemp_backup_VPS_by_rsync /etc/cron.d/lemp.rsync.cron | awk 'NR==1 {print $1}' | sed 's/*\///')
clear
echo "========================================================================="
echo "Hien tai LEMP tu dong sync data server toi VPS Backup $minutesrsync phut 1 lan"
echo "-------------------------------------------------------------------------"
echo "Neu muon thay doi thoi gian nay, ban phai [Disable Sync To VPS Backup] "
echo "-------------------------------------------------------------------------"
echo "truoc, sau do dung chuc nang [ Ket Noi VPS Backup ]"
/etc/lemp/menu/backup/lemp-rsync-backup-vps-menu.sh
exit
fi
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


prompt="Nhap lua chon cua ban: "
echo "========================================================================="
echo "Ban muon backup ca cac file backup website va database hay khong ?"
echo "========================================================================="
options=( "Backup Tat Ca Website Bao Gom Ca $mainsite" "Backup Tat Ca Website Tru $mainsite (Chua Backup Files) " "Huy Bo")
PS3="$prompt"
select opt in "${options[@]}"; do 

    case "$REPLY" in
    1) chooseaction="backuptatca"; break;;
    2) chooseaction="khongbackupmainsite"; break;;
    3) chooseaction="cancle"; break;;
    *) echo "Ban nhap sai ! Ban vui long chon so trong danh sach";continue;;
    esac  
done
make_script_backup () {
rm -rf /etc/lemp/lemp_backup_VPS_by_rsync
ipvpsbackup=$(grep "ipaddress" /etc/lemp/vps_backup_rsync.info | awk '{print $3}')
cat > "/etc/lemp/lemp_backup_VPS_by_rsync" <<END
#!/bin/bash
ssh root@$ipvpsbackup mkdir -p /home/VPS-$serverip 
ssh root@$ipvpsbackup mkdir -p /home/VPS-$serverip/etc
if [ "\$(grep "Createfolder" /etc/lemp/vps_backup_rsync.info | awk '{print $3}')" == "" ]; then
echo "-------------------------------------------------------------------------"
echo "Cai dat rsync and wget cho VPS Backup "
echo "-------------------------------------------------------------------------"
ssh root@$ipvpsbackup apt-get -y -q install rsync wget tar
ssh root@$ipvpsbackup yum -y -q install rsync wget tar
echo "Createfolder = thanhcong" >> /etc/lemp/vps_backup_rsync.info
fi
echo "Thoi gian thuc hien backup gan nhat: $(date +%T/%d/%m/%Y)" > /home/00-Time-Backup.txt
rsync -avzq -e ssh /etc/lemp/menu/backup/lemp-rsync-motd.sh root@$ipvpsbackup:/etc/motd
rsync -avz -e ssh --exclude={cache,.cache,lemp.conf} /home/ root@$ipvpsbackup:/home/VPS-$serverip/home/
rsync -avz -e ssh /var/lib/mysql/ root@$ipvpsbackup:/home/VPS-$serverip/mysql/
rsync -avz -e ssh /etc/nginx/ root@$ipvpsbackup:/home/VPS-$serverip/etc/nginx/
rsync -avz -e ssh /etc/my.cnf.d/ root@$ipvpsbackup:/home/VPS-$serverip/etc/my.cnf.d/
rsync -avz -e ssh /etc/php-fpm.d/ root@$ipvpsbackup:/home/VPS-$serverip/etc/php-fpm.d/
ssh root@$ipvpsbackup rm -rf /home/VPS-$serverip/etc/nginx/conf.d/$mainsite.conf
END
chmod +x /etc/lemp/lemp_backup_VPS_by_rsync
}

make_script_backup_no_sim_domain_com() {
rm -rf /etc/lemp/lemp_backup_VPS_by_rsync
ipvpsbackup=$(grep "ipaddress" /etc/lemp/vps_backup_rsync.info | awk '{print $3}')
cat > "/etc/lemp/lemp_backup_VPS_by_rsync" <<END
#!/bin/bash
ssh root@$ipvpsbackup mkdir -p /home/VPS-$serverip 
ssh root@$ipvpsbackup mkdir -p /home/VPS-$serverip/etc
if [ "\$(grep "Createfolder" /etc/lemp/vps_backup_rsync.info | awk '{print $3}')" == "" ]; then
echo "-------------------------------------------------------------------------"
echo "Cai dat rsync and wget cho VPS Backup "
echo "-------------------------------------------------------------------------"
ssh root@$ipvpsbackup apt-get -y -q install rsync wget tar
ssh root@$ipvpsbackup yum -y -q install rsync wget tar
echo "Createfolder = thanhcong" >> /etc/lemp/vps_backup_rsync.info
fi
echo "Thoi gian thuc hien backup gan nhat: $(date +%T/%d/%m/%Y)" > /home/00-Time-Backup.txt
rsync -avzq -e ssh /etc/lemp/menu/backup/lemp-rsync-motd.sh root@$ipvpsbackup:/etc/motd
rsync -avz -e ssh --exclude={$mainsite,cache,.cache,lemp.conf} /home/ root@$ipvpsbackup:/home/VPS-$serverip/home/
rsync -avz -e ssh /var/lib/mysql/ root@$ipvpsbackup:/home/VPS-$serverip/mysql/
rsync -avz -e ssh /etc/nginx/ root@$ipvpsbackup:/home/VPS-$serverip/etc/nginx/
rsync -avz -e ssh /etc/my.cnf.d/ root@$ipvpsbackup:/home/VPS-$serverip/etc/my.cnf.d/
rsync -avz -e ssh /etc/php-fpm.d/ root@$ipvpsbackup:/home/VPS-$serverip/etc/php-fpm.d/
ssh root@$ipvpsbackup rm -rf /home/VPS-$serverip/etc/nginx/conf.d/$mainsite.conf
END
chmod +x /etc/lemp/lemp_backup_VPS_by_rsync
}
###################################
#backuptatca
###################################
if [ "$chooseaction" = "backuptatca" ]; then
make_script_backup
echo "-------------------------------------------------------------------------"
echo "LEMP se backup tat ca website bao gom ca $mainsite"
echo "-------------------------------------------------------------------------"
echo "($mainsite chua toan bo backup cac website va database)"
###################################
#khongbackupmainsite
###################################
elif [ "$chooseaction" = "khongbackupmainsite" ]; then
make_script_backup_no_sim_domain_com
echo "-------------------------------------------------------------------------"
echo "LEMP se backup tat ca website tru $mainsite"
echo "-------------------------------------------------------------------------"
echo "($mainsite chua toan bo backup cac website va database)"
###################################
else 
clear && /etc/lemp/menu/backup/lemp-rsync-backup-vps-menu.sh
fi

prompt="Nhap lua chon cua ban: "
options=( "5 Phut 1 Lan" "10 Phut 1 Lan" "20 Phut 1 Lan" "40 Phut 1 Lan" "59 Phut 1 Lan" "Huy Bo")
  echo "========================================================================="
  echo "Cai Dat Thoi Gian Server Tu Dong Sync Data Toi VPS Backup"
  echo "========================================================================="
PS3="$prompt"
select opt in "${options[@]}"; do 

    case "$REPLY" in
    1) timersync="5phut1lan"; break;;
    2) timersync="10phut1lan"; break;;
    3) timersync="20phut1lan"; break;;
    4) timersync="40phut1lan"; break;;
    5) timersync="59phut1lan"; break;;
    6) timersync="huybo"; break;;
    *) echo "Ban nhap sai, Vui long nhap theo danh sach trong list";continue;;
    #*) echo "You typed wrong, Please type in the ordinal number on the list";continue;;
    esac  
done


set_time_run_rsync () {
rm -rf /etc/cron.d/lemp.rsync.cron
echo "SHELL=/bin/sh" > /etc/cron.d/lemp.rsync.cron
echo "*/$phut * * * * root /etc/lemp/lemp_backup_VPS_by_rsync >/dev/null 2>&1" >> /etc/cron.d/lemp.rsync.cron
}

###################################
#5phut1lan
###################################
if [ "$timersync" = "5phut1lan" ]; then
phut=5
#make_script_backup
set_time_run_rsync

###################################
#10phut1lan
###################################
elif [ "$timersync" = "10phut1lan" ]; then
phut=10
#make_script_backup
set_time_run_rsync
###################################
#20phut1lan
###################################
elif [ "$timersync" = "20phut1lan" ]; then
phut=20
#make_script_backup
set_time_run_rsync
###################################
#40phut1lan
###################################
elif [ "$timersync" = "40phut1lan" ]; then
phut=40
#make_script_backup
set_time_run_rsync
###################################
#59phut1lan
###################################
elif [ "$timersync" = "59phut1lan" ]; then
phut=59
#make_script_backup
set_time_run_rsync
else
rm -rf /etc/lemp/lemp_backup_VPS_by_rsync
clear
/etc/lemp/menu/backup/lemp-rsync-backup-vps-menu.sh
exit
###################################
fi

echo "-------------------------------------------------------------------------"
read -r -p "Ban muon LEMP auto Sync Data toi VPS Backup $phut phut 1 lan ? [y/N] " response
#read -r -p "You want lemp sync data to vps backup every $phut minutes  ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "-------------------------------------------------------------------------"
    echo "Please wait ..."
    sleep 2
systemctl restart cron.service
clear
  echo "========================================================================="
  echo "Thiet lap thoi gian auto Sync data thanh cong !"
  echo "-------------------------------------------------------------------------"
  echo "Cu $phut phut 1 lan, LEMP auto sync data toi VPS backup."
  echo "-------------------------------------------------------------------------"
  echo "Thu muc luu tru backup tren VPS backup: /home/VPS-$serverip"
  /etc/lemp/menu/backup/lemp-rsync-backup-vps-menu.sh
 
;;
*)
rm -rf /etc/cron.d/lemp.rsync.cron
rm -rf /etc/lemp/lemp_backup_VPS_by_rsync
clear
echo "========================================================================="
echo "Ban huy thiet lap cau hinh thoi gian backup VPS !"
  /etc/lemp/menu/backup/lemp-rsync-backup-vps-menu.sh
  exit
;;
esac
exit

