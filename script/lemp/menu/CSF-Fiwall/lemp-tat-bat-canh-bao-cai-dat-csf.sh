#!/bin/bash

. /home/lemp.conf


if [ -f /etc/csf/csf.conf ]; then
clear
echo "========================================================================="
echo "Chuc nang nay su dung de canh bao khi server chua cai dat CSF Firewall"
echo "-------------------------------------------------------------------------"
echo "Server da duoc cai dat CSF Firewall"
echo "========================================================================="
echo "Canh bao da tu dong TAT"
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
exit
fi

if [ ! -f /etc/lemp/tatthongbao.csf ]; then
echo "========================================================================="
echo "BAN NEN CAI DAT CSF FIREWALL DE BAO VE VPS/SERVER  !!!!!"
echo "========================================================================="
echo "Khi CSF Firewall chua cai dat, LEMP se hien canh bao tren LEMP Menu"
echo "-------------------------------------------------------------------------"
echo "Chuc nang nay su dung de BAT hoac TAT canh bao do."
echo "========================================================================="
echo "Canh bao [ Chua cai dat CSF ] tren LEMP Menu dang duoc BAT !"
echo "========================================================================="
read -r -p "Ban muon TAT canh bao nay ?  [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
    echo "------------------------------------------------------------------------"
    echo "Please wait....";sleep 1
	touch /etc/lemp/tatthongbao.csf
clear
echo "========================================================================="
	echo "Tat canh bao thanh cong !"
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
        ;;
    *)
        clear
echo "========================================================================="
echo "Ban chon sai, vui long chon lai !"
#echo "You typed wrong, Please fill accurately"
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
        ;;
esac
else
echo "========================================================================="
echo "BAN NEN CAI DAT CSF FIREWALL DE BAO VE VPS/SERVER  !!!!!"
echo "========================================================================="
echo "Khi CSF Firewall chua cai dat, LEMP se hien canh bao tren LEMP Menu"
echo "-------------------------------------------------------------------------"
echo "Chuc nang nay su dung de BAT hoac TAT canh bao do."
echo "========================================================================="
echo "Canh bao [ Chua cai dat CSF ] tren LEMP Menu dang duoc TAT !"
echo "========================================================================="
read -r -p "Ban muon BAT canh bao nay  ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
	rm -rf /etc/lemp/tatthongbao.csf
clear
echo "========================================================================="
	echo "BAT canh bao thanh cong  !"
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
        ;;
    *)
        clear
echo "========================================================================="
echo "Ban chon sai, vui long chon lai !"
#echo "You typed wrong, Please fill accurately"
/etc/lemp/menu/CSF-Fiwall/lemp-csf-firewall-menu.sh
        ;;
esac
fi
