#!/bin/bash 

. /home/lemp.conf

if [ -f /etc/csf/csf.conf ]; then
clear
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
else
echo "========================================================================= "
echo "Chuc nang nay can CSF Firewall de hoat dong"
echo "-------------------------------------------------------------------------"
echo "CSF Firewall chua duoc cai dat tren server! "
echo "-------------------------------------------------------------------------"
read -r -p "Ban co muon cai dat CSF Firewall ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
/etc/lemp/menu/CSF-Fiwall/lemp-cai-dat-csf-csf.sh
clear
echo "========================================================================= "
echo "Cai dat va config thanh cong CSF Firewall."
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
;;
esac
clear
echo "========================================================================= "
echo "Ban huy bo cai dat CSF Firewall ! "
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
exit
fi
