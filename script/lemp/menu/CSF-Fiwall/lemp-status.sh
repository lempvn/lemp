#!/bin/bash 
if [ -f /etc/csf/csf.conf ]; then
printf "=========================================================================\n"
printf "CSF Firewall should be installed to protect VPS/Server!!\n"

read -r -p "Are you sured want to uninstall CSF Firewall? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
echo "Prepare to remove CSF Firewall... "
sleep 1
cd /etc/csf
sh uninstall.sh
cd
clear
clear
echo "========================================================================= "
echo "Remove CSF Firewall from Server successfully "

/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
;;
    *)
       clear 
echo "========================================================================= "
echo "You cancel remove CSF FIREWALL"
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
        ;;
esac
clear 
echo "========================================================================= "
echo "You cancle remove CSF FIREWALL"
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
fi
echo "========================================================================= "
echo "CSF Firewall should be installed to protect VPS/Server !"
echo "-------------------------------------------------------------------------"
echo "CSF Firewall is not installed ! "
echo "-------------------------------------------------------------------------"
read -r -p "Do you want to install CSF Firewall on this VPS [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
/etc/lemp/menu/CSF-Fiwall/lemp-cai-dat-csf-csf.sh
clear
echo "========================================================================= "
echo "Successfully installed and configed CSF Firewall"
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
;;
esac
clear
echo "========================================================================= "
echo "You cancel install CSF Firewall ! "
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
exit
fi



