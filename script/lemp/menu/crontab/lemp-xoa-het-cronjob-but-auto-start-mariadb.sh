#!/bin/bash 
. /home/lemp.conf
echo "========================================================================="
read -r -p "Ban muon xoa het crontab hien tai? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
echo "Chuan bi xoa ... "
sleep 3
crontab -r
(crontab -u root -l ; echo "*/5 * * * * auto-start-mysql") | crontab -u root -
clear
echo "========================================================================= "
echo "LEMP hoan thanh xoa tat ca crontab. "
echo "-------------------------------------------------------------------------"
echo "[Auto re-start MySQL Server] duoc kich hoat lai."
/etc/lemp/menu/crontab/lemp-cronjob-menu.sh
;;
    *)
        echo ""
        ;;
esac
clear 
echo "========================================================================="
echo "Huy bo yeu cau xoa het cronjob."
/etc/lemp/menu/crontab/lemp-cronjob-menu.sh
