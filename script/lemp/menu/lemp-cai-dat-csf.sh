#!/bin/bash 
. /home/lemp.conf
if [ -f /etc/csf/csf.conf ]; then
clear
echo "========================================================================= "
echo "CSF Firewall da duoc cai dat tren server !"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
else
echo "-------------------------------------------------------------------------"
echo "Install CSF Firewall...."
sleep 2
/etc/lemp/menu/cai-csf-firewall-cai-dat-CSF-FIREWALL.sh
if [ -f /etc/csf/csf.conf ]; then
clear
echo "========================================================================= "
echo "Cai dat va config thanh cong CSF Firewall tren server"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
else
clear
echo "========================================================================= "
echo "Cai dat CSF Firewall that bai ! Ban vui long thu cai dat lai !"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
fi
fi
