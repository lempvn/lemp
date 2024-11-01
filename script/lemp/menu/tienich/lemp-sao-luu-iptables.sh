#!/bin/bash

. /home/lemp.conf


saoluuiptables ()
{
iptables-save > /etc/lemp/iptables.bak
echo "--------------------------------------------------------------------------"
echo "Please wait..."
sleep 1
clear
echo "========================================================================="
echo "Sao luu IPtables Firewall Rules hoan thanh!"
/etc/lemp/menu/lemp-iptables-firewall-manager-menu.sh
}
if [ -f /etc/lemp/iptables.bak ]; then
echo "--------------------------------------------------------------------------"
echo "Phat hien file back up cu cua IPtables Firewall"
echo "--------------------------------------------------------------------------"
read -r -p "Xoa file backup nay va tao file backup moi ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
	saoluuiptables
        ;;
    *)
    clear
    echo "========================================================================="
        echo "Ban da huy tao file backup moi"
        /etc/lemp/menu/lemp-iptables-firewall-manager-menu.sh
        ;;
esac
else
echo "========================================================================="
echo "Su dung chuc nang nay de sao luu IPtables Rules cho server"
echo "--------------------------------------------------------------------------"
echo "Chuan bi sao luu IPtables Rules"
sleep 3
saoluuiptables
fi
