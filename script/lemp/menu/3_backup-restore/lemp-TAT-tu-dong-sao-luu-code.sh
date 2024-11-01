#!/bin/bash

. /home/lemp.conf
website=$(cat /tmp/websiteautobackup)
websiteTO=`echo $website | tr '[a-z]' '[A-Z]'`
echo "-------------------------------------------------------------------------"
echo "Hien $websiteTO dang BAT che do tu dong backup"
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon TAT che do Auto backup cho $website  ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "-------------------------------------------------------------------------"
    echo "Please wait ..."
sleep 1
rm -rf /bin/lemp-backupcode-$website
if [ -f /etc/cron.d/lemp.code.cron ]; then
cat > "/tmp/removebackupcode" <<END
sed -i '/lemp-backupcode-$website/d' /etc/cron.d/lemp.code.cron
END
chmod +x /tmp/removebackupcode
/tmp/removebackupcode 
rm -rf /tmp/removebackupcode
systemctl restart cron.service
fi
clear
echo "========================================================================="
echo "TAT che do Auto backup cho $website thanh cong."
/etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh
        ;;
    *)
        clear
echo "========================================================================= "
echo "Huy TAT Auto Backup cho $website"
/etc/lemp/menu/3_backup-restore/lemp-sao-luu.sh
        ;;
esac
