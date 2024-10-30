#!/bin/bash 
. /home/lemp.conf
if [ -f /etc/csf/csf.conf ]; then
clear
echo "========================================================================= "
echo "CSF Firewall da duoc cai dat tren server !"
/etc/lemp/menu/lemp-kiem-tra-ddos.sh
else
echo "-------------------------------------------------------------------------"
echo "Install CSF Firewall...."
sleep 2
/etc/lemp/menu/cai-csf-firewall-cai-dat-CSF-FIREWALL.sh

clear
if [ -f /etc/csf/csf.conf ]; then
clear
echo "========================================================================= "
echo "Cai dat va config thanh cong CSF Firewall tren server"
/etc/lemp/menu/lemp-kiem-tra-ddos.sh
else
clear
echo "========================================================================= "
echo "Cai dat CSF Firewall that bai ! Ban vui long thu cai dat lai !"
/etc/lemp/menu/lemp-kiem-tra-ddos.sh
fi
fi

