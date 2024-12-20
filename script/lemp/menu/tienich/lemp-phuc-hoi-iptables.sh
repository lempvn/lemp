#!/bin/bash
. /home/lemp.conf
if [ ! -f /etc/lemp/iptables.bak ]; then
clear
echo "========================================================================="
echo "LEMP khong tim thay ban backup cua IPtables Firewall !"
/etc/lemp/menu/lemp-iptables-firewall-manager-menu.sh
exit
fi
echo "--------------------------------------------------------------------------"
echo "Tim thay ban backup cua IPtable Firewall"
echo "--------------------------------------------------------------------------"
echo "File Backup duoc tao vao: $(date -r /etc/lemp/iptables.bak +%H:%M/%F)"
echo "--------------------------------------------------------------------------"

read -r -p "Ban muon phuc hoi IPtables Firewall tu file backup nay ? [y/N] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
echo "--------------------------------------------------------------------------"
echo "Please wait..."
sleep 1
iptables-restore < /etc/lemp/iptables.bak
#service iptables save

clear
echo "========================================================================="
echo "Phuc hoi IPtables Firewall Rules hoan thanh !"
/etc/lemp/menu/lemp-iptables-firewall-manager-menu.sh
else
clear
echo "========================================================================="
echo "Ban da huy phuc hoi IPtables Firewall Rules !"
/etc/lemp/menu/lemp-iptables-firewall-manager-menu.sh
fi
