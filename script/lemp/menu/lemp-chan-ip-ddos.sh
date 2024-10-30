#!/bin/bash 

. /home/lemp.conf

if [ -f /etc/csf/csf.conf ]; then
echo "========================================================================="
echo "Chuc nang nay se Enable CSF Firewall neu ban dang Disable CSF!"
echo "-------------------------------------------------------------------------" 
echo -n "Nhap IP ban muon block [ENTER]: " 
read ipchan

test_csf=$(csf -v | awk 'NR==1 {print $NF}')

if [ "$ipchan" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap chinh xac."
/etc/lemp/menu/lemp-kiem-tra-ddos.sh
exit
fi


if [ "$(grep "$ipchan" /etc/csf/csf.allow | awk '{print $4}')" == "allowed" ]; then
clear
echo "========================================================================="
echo "IP: $ipchan da duoc them vao CSF.Allow"
echo "-------------------------------------------------------------------------"
echo "Ban hay remove $ipallow khoi CSF.Allow truoc khi block!"
/etc/lemp/menu/lemp-kiem-tra-ddos.sh
exit
fi


if [ ! "$(ping -c 1 $ipchan | tail -n +1 | head -1 | awk 'NR==1 {print $1}')" == "PING" ]; then
clear
echo "========================================================================="
echo "$ipchan khong phai la dia chi IP ! "
echo "-------------------------------------------------------------------------"
echo "Ban Vui long lam lai."
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
exit
fi

if [ "$test_csf" == "enable" ]; then
csf -e
fi
csf -d $ipchan
/etc/lemp/menu/CSF-Fiwall/lemp-re-start-khoi-dong-lai-csf-lfd.sh
clear
echo "========================================================================="
echo "CSF FireWall block IP $ipchand thanh cong . "
/etc/lemp/menu/lemp-kiem-tra-ddos.sh
fi

clear
echo "========================================================================= "
echo "Chuc nang nay su dung CSF Firewall de hoat dong"
echo "-------------------------------------------------------------------------"
echo "CSF Firewall chua duoc cai tren server!  "
echo "-------------------------------------------------------------------------"
read -r -p "Ban co muon cai dat CSF Firewall ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
/etc/lemp/menu/lemp-cai-dat-csf-ddos.sh
clear
echo "========================================================================= "
echo "Cai dat va config CSF Firewall thanh cong."
/etc/lemp/menu/lemp-kiem-tra-ddos.sh
;;
esac
clear
echo "========================================================================= "
echo "Ban da huy bo cai dat CSF Firewall ! "
/etc/lemp/menu/lemp-kiem-tra-ddos.sh
exit
fi
