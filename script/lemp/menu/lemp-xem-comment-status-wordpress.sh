#!/bin/bash 

. /home/lemp.conf
rans=`date |md5sum |cut -c '1-5'`
  echo "========================================================================="
  echo "Su dung chuc nang nay de xem commment status cho wordpress website"
  echo "========================================================================="
echo -n "Nhap ten website: " 
read website

if [ "$website" = "" ]; then
echo "========================================================================="
echo "Ban nhap sai, vui long nhap lai."
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
kiemtradomain3="^([[:alnum:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)+[[:alpha:]]{2,14}$";
if [[ ! "$website" =~ $kiemtradomain3 ]]; then
	website=`echo $website | tr '[A-Z]' '[a-z]'`
clear
echo "========================================================================="
echo "$website khong phai la domain!"
echo "-------------------------------------------------------------------------"
echo "Ban hay nhap lai !"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
if [ ! -f /etc/nginx/conf.d/$website.conf ]; then
clear
echo "========================================================================="
echo "$website khong ton tai tren he thong!"
echo "-------------------------------------------------------------------------"
echo "Ban hay nhap lai !"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
if [ ! -f /home/$website/public_html/wp-config.php ]; then
clear
echo "========================================================================="
echo "$website khong phai la wordpress blog hoac chua cai dat wordpress!"
echo "-------------------------------------------------------------------------"
echo "Vui long cai dat wp truoc hoac nhap domain khac"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi

echo "========================================================================="
echo "Tim thay $website tren he thong"
echo "-------------------------------------------------------------------------"
echo "$website dang su dung wordpress code"
echo "-------------------------------------------------------------------------"
echo "LEMP dang chuan bi lay thong tin comments"
echo "-------------------------------------------------------------------------"
echo "Please wait ...."
sleep 1
clear
echo "========================================================================="
echo "Commment Status For $website"
echo "-------------------------------------------------------------------------"
cd /home/$website/public_html
wp comment count --allow-root
cd
/etc/lemp/menu/lemp-wordpress-tools-menu.sh


