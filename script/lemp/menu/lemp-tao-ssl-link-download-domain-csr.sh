#!/bin/bash
. /home/lemp.conf
echo "========================================================================="
echo -n "Nhap domain [ENTER]: " 
read domainlaycsr
if [ "$domainlaycsr" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai !"
/etc/lemp/menu/lemp-tao-ssl-menu.sh
exit
fi
kiemtradomain3="^([[:alnum:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)+[[:alpha:]]{2,12}$";
if [[ ! "$domainlaycsr" =~ $kiemtradomain3 ]]; then
	domainlaycsr=`echo $domainlaycsr | tr '[A-Z]' '[a-z]'`
clear
echo "========================================================================="
echo "$domainlaycsr co le khong phai la domain !!"
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai  !"
/etc/lemp/menu/lemp-tao-ssl-menu.sh
exit
fi 

if [ -f /etc/nginx/ssl/$domainlaycsr/$domainlaycsr.csr ]; then
\cp -uf /etc/nginx/ssl/$domainlaycsr/$domainlaycsr.csr /home/$mainsite/private_html/
clear
echo "========================================================================= "
echo "Link download $domainlaycsr.csr:"
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/$domainlaycsr.csr"
echo "-------------------------------------------------------------------------"
echo "Link xem $domainlaycsr.conf mau: "
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport/$domainlaycsr.conf.txt"
/etc/lemp/menu/lemp-tao-ssl-menu.sh
exit
fi
clear
echo "========================================================================= "
echo "Ban chua tao $domainlaycsr.csr tren VPS !"
/etc/lemp/menu/lemp-tao-ssl-menu.sh
exit
fi
