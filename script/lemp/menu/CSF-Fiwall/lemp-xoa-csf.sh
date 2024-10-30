#!/bin/bash 
if [ -f /etc/csf/csf.conf ]; then
printf "=========================================================================\n"
printf "CSF Firewall nen duoc cai dat de bao ve VPS/Server.\n"
echo "-------------------------------------------------------------------------"
read -r -p "Ban chac chan muon remove CSF Firewall? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "-------------------------------------------------------------------------"
    echo "Please wait....";sleep 1
echo "Chuan bi remove CSF Firewall... "
sleep 1
yes | cp -rf /etc/csf/csf.conf /etc/lemp/csf.conf_bak
cd /etc/csf
sh uninstall.sh
cd
clear
clear
echo "========================================================================= "
echo "Remove CSF Firewall thanh cong ! "

/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
;;
    *)
       clear 
echo "========================================================================= "
echo "Ban huy remove CSF FIREWALL."
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
        ;;
esac
clear 
echo "========================================================================= "
echo "Ban huy remove CSF FIREWALL"
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
else
clear
echo "========================================================================= "
echo "VPS cua ban chua cai dat CSF Firewall ! "
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
exit
fi


