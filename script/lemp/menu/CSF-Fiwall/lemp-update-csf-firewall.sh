#!/bin/bash 
. /home/lemp.conf
versioncaidat_csf=$(csf -v | awk 'NR==1 {print $NF}')
if [ "$versioncaidat_csf" == "enable" ]; then
clear
echo  "CSF Firewall Wall dang tat tren VPS !"
echo "-------------------------------------------------------------------------"
echo "Ban hay enable CSF Firewall truoc khi dung chuc nang nay !"
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
exit
fi
versiononline_csf=$(csf -c | awk 'NR==1 {print $NF}')
versioncaidat_csf2=$(csf -v | awk 'NR==1 {print $2}')
if [ ! "$versioncaidat_csf2" == "$versiononline_csf" ]; then
echo "Please wait....";sleep 1
csf -u
clear
echo "========================================================================="
echo  "Ban da update CSF Firewall len phien ban moi nhat."
echo "-------------------------------------------------------------------------"
echo  "Phien ban: $(csf -v | awk 'NR==1 {print $2}')"
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
else
clear
echo "========================================================================="
echo  "Ban dang su dung CSF Firewall phien ban moi nhat."
echo "-------------------------------------------------------------------------"
echo "Phien Ban:  $(csf -v | awk 'NR==1 {print $2}' | sed 's/v//')"
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
exit
fi


