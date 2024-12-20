#!/bin/bash 

. /home/lemp.conf

echo "========================================================================="
echo "Su dung chuc nang nay de CLOSE port (INPUT) cho server bang IPtables"
echo "-------------------------------------------------------------------------"
echo -n "Nhap port ban muon CLOSE [ENTER]: " 
read portclose
if [ "$portclose" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, hay nhap chinh xac."
/etc/lemp/menu/lemp-iptables-firewall-manager-menu.sh
exit
fi

if [[ ! ${portclose} =~ ^[0-9]+$ ]] ;then 
clear
echo "========================================================================="
echo "Port ban nhap: ${portclose} khong phai la so tu nhien."
echo "-------------------------------------------------------------------------"
echo "Ban hay lam lai !" 
/etc/lemp/menu/lemp-iptables-firewall-manager-menu.sh
exit
fi

if [ "$(iptables -L -n | grep :$portclose | awk 'NR==1 {print $1}')" == "DROP" ]; then
clear
echo "========================================================================="
echo "Port $portclose dang CLOSED."
echo "-------------------------------------------------------------------------"
echo "Ban khong can phai re-close no! " 
/etc/lemp/menu/lemp-iptables-firewall-manager-menu.sh
exit
fi

if ! [[ $portclose -ge 1 && $portclose -le 65535  ]] ; then  
clear
echo "========================================================================="
echo "$portclose khong dung!"
echo "-------------------------------------------------------------------------"
echo "Port cua VPS phai la so tu nhien nam trong khoang (1 - 65535)."
echo "-------------------------------------------------------------------------"
echo "Ban hay lam lai !" 
/etc/lemp/menu/lemp-iptables-firewall-manager-menu.sh
exit
fi  

if [ "$(iptables -L -n | grep :80 | awk 'NR==1 {print $1}')" == "ACCEPT" ]; then
if [ $portclose = 80 ]; then
echo "========================================================================="
echo "Ban dang muon dong port 80"
echo "-------------------------------------------------------------------------"
echo "Neu ban dong port nay, nobody can access to website on this server"
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon dong port 80 ?  [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
clear
echo "========================================================================="
	echo "Port ban muon CLOSE: $portclose"
	echo "-------------------------------------------------------------------------"
	iptables -I INPUT -p tcp --dport $portclose -j DROP
	# service iptables save # lenh nay chi dung voi Centos
/etc/lemp/menu/lemp-iptables-firewall-manager-menu.sh
        ;;
    *)
        clear
echo "========================================================================="
echo "Ban huy close port 80"
/etc/lemp/menu/lemp-iptables-firewall-manager-menu.sh
        ;;
esac
exit
fi
fi

if [ "$(iptables -L -n | grep :25 | awk 'NR==1 {print $1}')" == "ACCEPT" ]; then
if [ $portclose = 25 ]; then
echo "========================================================================="
echo "Ban dang muon dong port 25"
echo "-------------------------------------------------------------------------"
echo "Neu ban dong port nay, email service se khong the hoat dong chinh xac!"
echo "-------------------------------------------------------------------------"
read -r -p "You want to close port 25 ?  [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
clear
echo "========================================================================="
	echo "Port ban muon CLOSE: $portclose"
	echo "-------------------------------------------------------------------------"
	iptables -I INPUT -p tcp --dport $portclose -j DROP
	#service iptables save # lenh nay chi dung voi Centos
/etc/lemp/menu/lemp-iptables-firewall-manager-menu.sh
        ;;
    *)
        clear
echo "========================================================================="
echo "Ban huy close port 25"
/etc/lemp/menu/lemp-iptables-firewall-manager-menu.sh
        ;;
esac
exit
fi
fi


if [ "$(iptables -L -n | grep :21 | awk 'NR==1 {print $1}')" == "ACCEPT" ]; then
if [ $portclose = 21 ]; then
echo "========================================================================="
echo "Ban dang muon dong port 21"
echo "-------------------------------------------------------------------------"
echo "Neu ban dong port nay, dich vu FTP khong the hoat dong!"
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon dong port 21 ?  [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
clear
echo "========================================================================="
	echo "Port ban muon CLOSE: $portclose"
	echo "-------------------------------------------------------------------------"
	iptables -I INPUT -p tcp --dport $portclose -j DROP
	#service iptables save # lenh nay chi dung voi Centos
/etc/lemp/menu/lemp-iptables-firewall-manager-menu.sh
        ;;
    *)
        clear
echo "========================================================================="
echo "Ban huy close port 21"
/etc/lemp/menu/lemp-iptables-firewall-manager-menu.sh
        ;;
esac
exit
fi
fi


if [ "$(iptables -L -n | grep :443 | awk 'NR==1 {print $1}')" == "ACCEPT" ]; then
if [ $portclose = 443 ]; then
echo "========================================================================="
echo "Ban dang muon dong port 443"
echo "-------------------------------------------------------------------------"
echo "Neu ban dong port nay, Tat ca website dung SSL se khong the truy cap!"
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon dong port 443 ?  [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
clear
echo "========================================================================="
	echo "Port ban muon CLOSE: $portclose"
	echo "-------------------------------------------------------------------------"
	iptables -I INPUT -p tcp --dport $portclose -j DROP
	# service iptables save # lenh nay chi dung voi Centos
/etc/lemp/menu/lemp-iptables-firewall-manager-menu.sh
        ;;
    *)
        clear
echo "========================================================================="
echo "Ban da huy close port 443"
/etc/lemp/menu/lemp-iptables-firewall-manager-menu.sh
        ;;
esac
exit
fi
fi


if [ $portclose = 22 ]; then
clear
echo "========================================================================="
echo "Ban khong the close SSH port !"
/etc/lemp/menu/lemp-iptables-firewall-manager-menu.sh
exit
fi

if [ $portclose = 3306 ]; then
clear
echo "========================================================================="
echo "Ban khong the close MySQL port !"
/etc/lemp/menu/lemp-iptables-firewall-manager-menu.sh
exit
fi

if [ $portclose = $priport ]; then
clear
echo "========================================================================="
echo "Port $portclose la Phpmyadmin port. Hay su dung chuc nang "
echo "-------------------------------------------------------------------------"
echo "[Open/Close Phpmyadmin Port] neu ban muon Open/Close port $portclose!" 
/etc/lemp/menu/lemp-iptables-firewall-manager-menu.sh
exit
fi

clear
echo "========================================================================="
echo "Port ban muon CLOSE: $portclose"
echo "-------------------------------------------------------------------------"
iptables -I INPUT -p tcp --dport $portclose -j DROP
#service iptables save # lenh nay chi dung voi Centos
/etc/lemp/menu/lemp-iptables-firewall-manager-menu.sh
exit
fi
fi
