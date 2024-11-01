#!/bin/bash 
. /home/lemp.conf

echo "========================================================================="
echo "Su dung chuc nang nay de OPEN port (INPUT) cho server bang IPtables"
echo "-------------------------------------------------------------------------"
echo -n "Nhap port ban muon OPEN [ENTER]: " 
read portopen
if [ "$portopen" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, hay nhap chinh xac."
/etc/lemp/menu/lemp-iptables-firewall-manager-menu.sh
exit
fi
if [[ ! ${portopen} =~ ^[0-9]+$ ]] ;then 
clear
echo "========================================================================="
echo "Port ban nhap: ${portopen} khong phai la so tu nhien."
echo "-------------------------------------------------------------------------"
echo "Ban hay lam lai !" 
/etc/lemp/menu/lemp-iptables-firewall-manager-menu.sh
exit
fi
if ! [[ $portopen -ge 1 && $portopen -le 65535  ]] ; then  
clear
echo "========================================================================="
echo "$portopen khong dung!"
echo "-------------------------------------------------------------------------"
echo "Port phai la so tu nhien nam trong khoang (1 - 65535)."
echo "-------------------------------------------------------------------------"
echo "Ban hay lam lai !" 
/etc/lemp/menu/lemp-iptables-firewall-manager-menu.sh
exit
fi  
if [ $portopen = $priport ]; then
clear
echo "========================================================================="
echo "Port $portopen la Phpmyadmin port. Ban hay su dung chuc nang "
echo "-------------------------------------------------------------------------"
echo "[Open/Close Phpmyadmin Port] nen ban muon Open/Close port $portopen !" 
/etc/lemp/menu/lemp-iptables-firewall-manager-menu.sh
exit
fi
if [ "$(iptables -L -n | grep :$portopen | awk 'NR==1 {print $1}')" == "ACCEPT" ]; then
clear
echo "========================================================================="
echo "Port $portopen dang Open."
echo "-------------------------------------------------------------------------"
echo "Ban khong can mo lai no! " 
/etc/lemp/menu/lemp-iptables-firewall-manager-menu.sh
exit
fi
echo "-------------------------------------------------------------------------"
echo "Please wait..."
sleep 1
clear
echo "========================================================================="
echo "Port ban muon OPEN: $portopen"
echo "-------------------------------------------------------------------------"
iptables -I INPUT -p tcp --dport $portopen -j ACCEPT

/etc/lemp/menu/lemp-iptables-firewall-manager-menu.sh
exit
fi
fi
