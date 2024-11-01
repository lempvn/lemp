#!/bin/bash
. /home/lemp.conf
echo "========================================================================="
echo "Dung chuc nang nay de xem thong tin dia chi IP & Nameserver cua 1 website"
echo "-------------------------------------------------------------------------"
echo -n "Nhap ten domain [ENTER]: " 
read website
if [ "$website" = "" ]; then
clear
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai!"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi

kiemtradomain3="^([[:alnum:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)+[[:alpha:]]{2,6}$";
if [[ ! "$website" =~ $kiemtradomain3 ]]; then
	website=`echo $website | tr '[A-Z]' '[a-z]'`
clear
echo "========================================================================="
echo "$website Co the khong dung dinh dang domain!"
echo "-------------------------------------------------------------------------"
echo "Ban hay lam lai !"
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi
echo "-------------------------------------------------------------------------"
echo "Please wait....";sleep 1
if [ "$(host -t a $website | awk 'NR==1 {print $3}')" == "address" ]; then
clear
echo "========================================================================="
echo "Infomation for $website:"
echo "-------------------------------------------------------------------------"
echo "IP Address: $(host -t a $website | awk 'NR==1 {print $4}')"
echo "-------------------------------------------------------------------------"
echo "Nameserver:"
echo "-------------------------------------------------------------------------"
host -t ns $website
/etc/lemp/menu/tienich/lemp-tien-ich.sh
else
clear
echo "========================================================================="
echo "Co the domain $website ban nhap"
echo "-------------------------------------------------------------------------"
echo "Khong tro toi bat ky IP nao hoac chua dang ky."
/etc/lemp/menu/tienich/lemp-tien-ich.sh
exit
fi

