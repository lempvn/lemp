#!/bin/bash 

. /home/lemp.conf
if [ -f /etc/csf/csf.conf ]; then
if [ "$(cat /etc/csf/csf.deny | awk 'NR==1 {print $1}')" == "" ]; then
clear
echo "========================================================================="
echo "Hien tai CSF Firewall chua block IP nao."
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
exit
fi
fi
if [ -f /etc/csf/csf.conf ]; then
echo "========================================================================="
test_csf=$(csf -v | awk 'NR==1 {print $NF}')
if [ "$test_csf" == "enable" ]; then
echo "Chuc nang nay se bat CSF Firewall neu ban dang tat no."
echo "-------------------------------------------------------------------------" 
fi
if [ "$test_csf" == "enable" ]; then
csf -e
fi
echo "Cho xiu...."
sleep 1
rm -rf /home/$mainsite/private_html/csf-block.txt
cp /etc/csf/csf.deny /home/$mainsite/private_html/csf-block.txt
chmod -R 644 /home/$mainsite/private_html/csf-block.txt
sed -i '1s/^/Danh sach cac IP bi CSF FireWall Block - Created by LEMP \n\n/' /home/$mainsite/private_html/csf-block.txt
clear
echo "========================================================================= "
echo "Link list IP blocked boi CSF Firewall:"
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/csf-block.txt"
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh

else
echo "========================================================================= "
echo "Chuc nang nay can CSF Firewall de hoat dong"
echo "-------------------------------------------------------------------------"
echo "CSF Firewall chua duoc cai dat tren server! "
echo "-------------------------------------------------------------------------"
read -r -p "Ban co muon cai dat CSF Firewall vao server [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
/etc/lemp/menu/CSF-Fiwall/lemp-cai-dat-csf-csf.sh
clear
echo "========================================================================= "
echo "Cai dat va config thanh cong CSF Firewall"
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
;;
esac
clear
echo "========================================================================= "
echo "Ban huy bo cai dat CSF Firewall ! "
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
exit
fi
