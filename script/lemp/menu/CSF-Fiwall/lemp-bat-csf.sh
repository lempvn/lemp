#!/bin/bash 

. /home/lemp.conf
if [ -f /etc/csf/csf.conf ]; then
csf -e
clear
echo "========================================================================= "
echo "Bat CSF Firewall thanh cong "
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
else
clear
echo "========================================================================= "
echo "Chuc nang nay can CSF Firewall de hoat dong"
echo "-------------------------------------------------------------------------"
echo "CSF Firewall chua duoc cai dat tren server! "
echo "-------------------------------------------------------------------------"
read -r -p "Ban co muon cai dat CSF Firewall vao server [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
/etc/lemp/menu/CSF-Fiwall/lemp-cai-dat-csf-csf.sh
;;
esac
clear
echo "========================================================================= "
echo "Ban huy bo cai dat CSF Firewall ! "
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
exit
fi
