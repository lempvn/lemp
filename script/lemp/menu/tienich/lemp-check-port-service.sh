#!/bin/bash 

. /home/lemp.conf

echo "========================================================================="
echo -n "Nhap port ban muon kiem tra [ENTER]: " 
read portservice
if [ "$portservice" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, hay nhap chinh xac."
/etc/lemp/menu/lemp-iptables-firewall-manager-menu.sh
exit
fi

if [[ ! ${portservice} =~ ^[0-9]+$ ]] ;then 
clear
echo "========================================================================="
echo "Port ban nhap: ${portservice} khong phai la so tu nhien."
echo "-------------------------------------------------------------------------"
echo "Ban hay lam lai !" 
/etc/lemp/menu/lemp-iptables-firewall-manager-menu.sh
exit
fi
if ! [[ $portservice -ge 1 && $portservice -le 65535  ]] ; then  
clear
echo "========================================================================="
echo "$portservice khong dung!"
echo "-------------------------------------------------------------------------"
echo "Port phai la so tu nhien nam trong khoang (1 - 65535)."
echo "-------------------------------------------------------------------------"
echo "Ban hay lam lai !" 
/etc/lemp/menu/lemp-iptables-firewall-manager-menu.sh
exit
fi  

test_port=$(lsof -i:$portservice | awk 'NR==1 {print $1}')
if [ "$test_port" == "" ]; then
clear
echo "========================================================================= "
echo "Khong co dich vu nao su dung port $portservice "
/etc/lemp/menu/lemp-iptables-firewall-manager-menu.sh
exit
fi
echo "Please wait....";sleep 1
clear
echo "========================================================================="
echo "Dich vu dang su dung port $portservice: "
echo "-------------------------------------------------------------------------"
lsof -i:$portservice
/etc/lemp/menu/lemp-iptables-firewall-manager-menu.sh
exit
fi
fi
