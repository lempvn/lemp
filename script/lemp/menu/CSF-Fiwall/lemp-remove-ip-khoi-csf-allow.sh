#!/bin/bash 

. /home/lemp.conf
if [ -f /etc/csf/csf.conf ]; then
echo "========================================================================="
test_csf=$(csf -v | awk 'NR==1 {print $NF}')
if [ "$test_csf" == "enable" ]; then
echo "Chuc nang nay se bat CSF Firewall neu ban dang tat no."
echo "-------------------------------------------------------------------------" 
fi
fi
echo -n "Nhap IP ban muon remove khoi CSF.Allow [ENTER]: " 
read ipremove
if [ "$ipremove" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap chinh xac"
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
exit
fi


if [ ! "$(ping -c 1 $ipremove | tail -n +1 | head -1 | awk 'NR==1 {print $1}')" == "PING" ]; then
clear
echo "========================================================================="
echo "$ipremove khong phai la dia chi IP ! "
echo "-------------------------------------------------------------------------"
echo "Ban Vui long lam lai."
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
exit
fi


if [ "$(grep "$ipremove" /etc/csf/csf.allow | awk '{print $4}')" == "" ]; then
clear
echo "========================================================================="
echo "IP: $ipremove khong co trong CSF.Allow"
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
exit
fi

if [ "$test_csf" == "enable" ]; then
csf -e
fi
csf -ar "$ipremove"
/etc/lemp/menu/CSF-Fiwall/lemp-re-start-khoi-dong-lai-csf-lfd.sh
clear
echo "========================================================================="
echo "IP $ipremove da remove khoi CSF.ALLOW"
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
