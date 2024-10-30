#!/bin/bash
. /home/lemp.conf
if [ ! -f /etc/lemp/netdatasite.info ]; then
clear
echo "========================================================================="
echo "Ban chua cai dat domain NetData cho Server !"
/etc/lemp/menu/22_netdata/lemp-netdata-menu.sh
exit
fi
netdatasite=$(cat /etc/lemp/netdatasite.info)
if [ ! -f /etc/nginx/conf.d/$netdatasite.conf ]; then
clear
echo "========================================================================="
echo "Qua trinh thay Domain NetData gap loi!"
echo "-------------------------------------------------------------------------"
echo "Ban vui long kiem tra lai"
/etc/lemp/menu/22_netdata/lemp-netdata-menu.sh
exit
fi
echo "========================================================================= "
echo "Su dung chuc nang nay de thay Domain NetData sang Domain Khac"
echo "-------------------------------------------------------------------------"
read -r -p "Ban muon thay $netdatasite bang domain khac? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
sleep 1
echo "-------------------------------------------------------------------------"
echo -n "Nhap domain NetData moi [ENTER]: " 
read website
website=`echo $website | tr '[A-Z]' '[a-z]'`
if [ "$website" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai!"
/etc/lemp/menu/22_netdata/lemp-netdata-menu.sh
exit
fi

kiemtradomain3="^([[:alnum:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)+[[:alpha:]]{2,12}$";
if [[ ! "$website" =~ $kiemtradomain3 ]]; then
	website=`echo $website | tr '[A-Z]' '[a-z]'`
clear
echo "========================================================================="
echo "$website co le khong phai la domain !!"
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai  !"
/etc/lemp/menu/22_netdata/lemp-netdata-menu.sh
exit
fi

if [ "$netdatasite" = "$website" ]; then
clear
echo "========================================================================="
echo "Please type in the other domain"
/etc/lemp/menu/22_netdata/lemp-netdata-menu.sh
exit
fi

if [ -f /etc/nginx/conf.d/$website.conf ]; then
clear
echo "========================================================================="
echo "Phat hien $website da ton tai tren he thong!"
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai  !"
/etc/lemp/menu/22_netdata/lemp-netdata-menu.sh
exit
fi
echo "-------------------------------------------------------------------------"
echo "Please wait ..."

mv /etc/nginx/conf.d/$netdatasite.conf /etc/nginx/conf.d/$website.conf
sed -i "s/server_name ${netdatasite};/server_name ${website};/g" /etc/nginx/conf.d/$website.conf


systemctl restart nginx

echo "$website" > /etc/lemp/netdatasite.info
clear
echo "========================================================================="
echo "Thay Domain moi cho NetData thanh cong !"
echo "-------------------------------------------------------------------------"
echo "Hay tro $website toi $serverip"
echo "-------------------------------------------------------------------------"
echo "va truy cap domain nay tren trinh duyet de su dung NetData"
/etc/lemp/menu/22_netdata/lemp-netdata-menu.sh
;;
esac
clear
echo "========================================================================="
echo "Ban da cancel thay doi domain NetData"
/etc/lemp/menu/22_netdata/lemp-netdata-menu.sh
