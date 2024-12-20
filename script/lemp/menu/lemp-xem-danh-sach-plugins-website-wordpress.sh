#!/bin/bash 

. /home/lemp.conf
rans=`date |md5sum |cut -c '1-5'`
  echo "========================================================================="
  echo "Su dung chuc nang nay de xem trang thai Plugins & Themes"
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
echo "$website co le khong phai la domain!"
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai !"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
if [ ! -f /etc/nginx/conf.d/$website.conf ]; then
clear
echo "========================================================================="
echo "Khong tim thay $website tren he thong"
echo "-------------------------------------------------------------------------"
echo "Ban vui long thu lai !"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi
if [ ! -f /home/$website/public_html/wp-config.php ]; then
clear
echo "========================================================================="
echo "$website co the khong phai wordpress web hoac chua cai dat WP"
echo "-------------------------------------------------------------------------"
echo "Vui long cai dat Wordpress code truoc hoac thu domain khac"
/etc/lemp/menu/lemp-wordpress-tools-menu.sh
exit
fi

echo "========================================================================="
echo "Tim thay $website dang su dung wordpress code tren he thong"
echo "-------------------------------------------------------------------------"
echo "THEMES:"
cd /home/$website/public_html
wp theme list --allow-root
echo "PLUGINS:"
wp plugin list --allow-root
cd
