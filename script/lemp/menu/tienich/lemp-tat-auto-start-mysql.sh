#!/bin/sh
. /home/lemp.conf
echo "========================================================================="
echo "Hien tai chuc nang [Auto re-start MySQL Server] dang duoc BAT"
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon TAT chuc nang nay ?  [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "-------------------------------------------------------------------------"
    echo "Please wait...."; sleep 1
    rm -rf /etc/cron.d/lemp-auto-start-mysql.cron
    systemctl restart cron.service
    clear
    echo "========================================================================="
echo "Disable [Auto re-start MySQL Server] thanh cong !"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
        ;;
    *)
       clear
    echo "========================================================================="
   echo "Ban khong disable [Auto re-start MySQL Server]"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
        ;;
esac

