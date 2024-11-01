#!/bin/bash 

. /home/lemp.conf
if [ -f /etc/csf/csf.conf ]; then
echo "========================================================================="
test_csf=$(csf -v | awk 'NR==1 {print $NF}')
if [ "$test_csf" == "enable" ]; then
echo "Chuc nang nay se bat CSF Firewall neu ban dang tat no."
echo "-------------------------------------------------------------------------" 
fi
echo "IP add vao CSF.Allow se khong bi CSF Firewall Block"
echo "-------------------------------------------------------------------------" 
echo -n "Nhap dia chi IP [ENTER]: " 
read ipallow
if [ "$test_csf" == "enable" ]; then
csf -e
fi
if [ "$ipallow" = "" ]; then
clear
echo "========================================================================= "
echo "Ban nhap sai, vui long nhap chinh xac"
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
exit
fi

if [ ! "$(ping -c 1 $ipallow | tail -n +1 | head -1 | awk 'NR==1 {print $1}')" == "PING" ]; then
clear
echo "========================================================================="
echo "$ipallow khong phai la dia chi IP ! "
echo "-------------------------------------------------------------------------"
echo "Ban vui long lam lai."
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
exit
fi


if [ "$(grep "$ipallow" /etc/csf/csf.deny | awk '{print $4}')" == "denied" ]; then
clear
echo "========================================================================="
echo "IP: $ipallow da bi CSF Firewall block truoc do."
echo "-------------------------------------------------------------------------"
echo "Hay unblock $ipallow truoc khi ban them vao CSF.Allow"
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
exit
fi
csf -a "$ipallow"
/etc/lemp/menu/CSF-Fiwall/lemp-re-start-khoi-dong-lai-csf-lfd.sh
clear
echo "========================================================================= "
echo "IP $ipallow da duoc them vao csf.allow thanh cong"
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
;;
esac
clear
echo "========================================================================= "
echo "Ban huy bo cai dat CSF Firewall ! "
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
exit
fi
