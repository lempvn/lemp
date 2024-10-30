#!/bin/sh
. /home/lemp.conf
echo "========================================================================="
echo "Voi VPS it RAM, doi khi Free RAM qua it, MySQL se bi ngung hoat dong"
echo "-------------------------------------------------------------------------"
echo "Sau khi ban kich hoat chuc nang [Auto re-start MySQL Server] "
echo "-------------------------------------------------------------------------"
echo "LEMP se kiem tra trang thai hoat dong cua MySQL service 5 phut 1 lan"
echo "-------------------------------------------------------------------------"
echo "Neu MySQL bi stop, sau toi da 5 phut LEMP se BAT MySQL tro lai "
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon Enable chuc nang [Auto re-start MySQL Server]?  [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
 echo "-------------------------------------------------------------------------" 
    echo "Please wait..."
sleep 1
\cp -uf /etc/lemp/menu/tienich/lemp-auto-start-mysql.sh /bin/lemp-auto-start-mysql
chmod +x /bin/lemp-auto-start-mysql
echo "SHELL=/bin/sh" > /etc/cron.d/lemp-auto-start-mysql.cron
echo "*/5 * * * * root /bin/lemp-auto-start-mysql >/dev/null 2>&1" >> /etc/cron.d/lemp-auto-start-mysql.cron
systemctl restart cron.service
    clear
    echo "========================================================================="
echo "Enable chuc nang [Auto re-start MySQL Server] thanh cong !"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
        ;;
    *)
       clear
    echo "========================================================================="
   echo "Ban khong enable chuc nang [Auto re-start MySQL Server] !"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
        ;;
esac
