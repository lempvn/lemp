#!/bin/bash 

. /home/lemp.conf


if [ -f /etc/csf/csf.conf ]; then
echo "========================================================================="
echo "Chuc nang nay se Enable CSF Firewall neu ban dang Disable CSF!""
echo "-------------------------------------------------------------------------" 
echo -n "Nhap bi ban muon unblock [ENTER]: " 
read ipbochan
if [ "$ipbochan" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap chinh xac"
/etc/lemp/menu/lemp-kiem-tra-ddos.sh
exit
fi
csf -e
csf -dr "$ipbochan"
    csf -r
clear
echo "========================================================================="
echo "IP $ipbochan bay gio cho the truy cap Website hoac VPS"
/etc/lemp/menu/lemp-kiem-tra-ddos.sh
fi
clear

echo "========================================================================= "
echo "Chuc nang nay su dung CSF Firewall de hoat dong"
echo "CSF Firewall chua duoc cai tren server! "
read -r -p "Ban co muon cai dat CSF Firewall ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
/etc/lemp/menu/lemp-cai-dat-csf-ddos.sh
clear
echo "========================================================================= "
echo "Cai dat va config CSF Firewall thanh cong"
/etc/lemp/menu/lemp-kiem-tra-ddos.sh
;;
esac
clear
echo "========================================================================= "
echo "Ban da cancel cai dat CSF Firewall ! "
/etc/lemp/menu/lemp-kiem-tra-ddos.sh
exit
fi
