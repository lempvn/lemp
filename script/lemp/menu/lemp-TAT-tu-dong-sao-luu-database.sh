#!/bin/sh

. /home/lemp.conf
dataname=$(cat /tmp/databaseautobackup)

echo "-------------------------------------------------------------------------"
echo "Database $dataname dang duoc BAT che do Auto Backup"
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon TAT Auto Backup cho database $dataname  ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "-------------------------------------------------------------------------"
    echo "Please wait ..."
sleep 1
rm -rf /bin/lemp-backupdb-$dataname
if [ -f /etc/cron.d/lemp.db.cron ]; then
cat > "/tmp/removebackupdb" <<END
sed -i '/lemp-backupdb-$dataname/d' /etc/cron.d/lemp.db.cron
END
chmod +x /tmp/removebackupdb
/tmp/removebackupdb 
rm -rf /tmp/removebackupdb
service crond restart
fi
clear
echo "========================================================================="
echo "TAT che do tu dong backup Database cho $dataname thanh cong."
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
        ;;
    *)
        clear
echo "========================================================================= "
echo "Huy TAT che do auto backup Database cho $dataname !"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
        ;;
esac
