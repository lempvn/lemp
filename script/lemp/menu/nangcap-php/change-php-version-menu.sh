#!/bin/bash 

. /home/lemp.conf
prompt="Nhap lua chon cua ban (0-Thoat):"
php_version=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")

if [ "$php_version" == "7.2" ]; then
options=( "PHP 7.4" "PHP 7.3" "PHP 7.2 (Current)" "PHP 7.1" "PHP 7.0" "PHP 5.6" "PHP 5.5" "PHP 5.4")
elif [ "$php_version" == "7.4" ]; then
options=( "PHP 7.4 (Current)" "PHP 7.3" "PHP 7.2" "PHP 7.1" "PHP 7.0" "PHP 5.6" "PHP 5.5" "PHP 5.4")
elif [ "$php_version" == "7.3" ]; then
options=( "PHP 7.4" "PHP 7.3 (Current)" "PHP 7.2" "PHP 7.1" "PHP 7.0" "PHP 5.6" "PHP 5.5" "PHP 5.4")
elif [ "$php_version" == "7.1" ]; then
options=( "PHP 7.4" "PHP 7.3" "PHP 7.2" "PHP 7.1 (Current)" "PHP 7.0" "PHP 5.6" "PHP 5.5" "PHP 5.4")
elif [ "$php_version" == "7.0" ]; then
options=( "PHP 7.4" "PHP 7.3" "PHP 7.2" "PHP 7.1" "PHP 7.0 (Current)" "PHP 5.6" "PHP 5.5" "PHP 5.4")
elif [ "$php_version" == "5.6" ]; then
options=( "PHP 7.4" "PHP 7.3" "PHP 7.2" "PHP 7.1" "PHP 7.0" "PHP 5.6 (Current)" "PHP 5.5" "PHP 5.4")
elif [ "$php_version" == "5.5" ]; then
options=( "PHP 7.4" "PHP 7.3" "PHP 7.2" "PHP 7.1" "PHP 7.0" "PHP 5.6" "PHP 5.5 (Current)" "PHP 5.4")
elif [ "$php_version" == "5.4" ]; then
options=( "PHP 7.4" "PHP 7.3" "PHP 7.2" "PHP 7.1" "PHP 7.0" "PHP 5.6" "PHP 5.5" "PHP 5.4 (Current)")
else
echo "Phien ban PHP hien tai: "$php_version
options=( "PHP 7.4" "PHP 7.3" "PHP 7.2" "PHP 7.1" "PHP 7.0" "PHP 5.6" "PHP 5.5" "PHP 5.4")
fi

printf "=========================================================================\n"
printf "                LEMP - Quan Ly VPS/Server by LEMP.VN \n"
printf "=========================================================================\n"
printf "                       Chon PHP Version Cho Server\n"

if [ ! "$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))" == "6" ]; then
printf "                      Phien ban PHP khuyen dung: 7.4\n"
else
if [ -f /etc/php.d/imagick.ini ]; then
printf "                      Phien ban PHP khuyen dung: 7.2\n"
else
printf "                      Phien ban PHP khuyen dung: 7.3\n"
fi
fi
#printf "              Phien ban 7.3 va 7.4 hien tai chua hoat dong on dinh\n"

printf "=========================================================================\n"
PS3="$prompt"
select opt in "${options[@]}"; do

case "$REPLY" in
1) chonphpversion="74"; break;;
2) chonphpversion="73"; break;;
3) chonphpversion="72"; break;;
4) chonphpversion="71"; break;;
5) chonphpversion="70"; break;;
6) chonphpversion="56"; break;;
7) chonphpversion="55"; break;;
8) chonphpversion="54"; break;;
#9) chonphpversion="cancle"; break;;
0) chonphpversion="cancel"; break;;
*) echo "Ban nhap sai, vui long nhap theo so thu tu trong danh sach";continue;;

esac  
done
###################################
#7.4
###################################
if [ "$chonphpversion" = "74" ]; then
/etc/lemp/menu/nangcap-php/setup-php-74.sh
#7.3
###################################
elif [ "$chonphpversion" = "73" ]; then
/etc/lemp/menu/nangcap-php/setup-php-73.sh
#7.2
###################################
elif [ "$chonphpversion" = "72" ]; then
/etc/lemp/menu/nangcap-php/setup-php-72.sh
#7.1
###################################
elif [ "$chonphpversion" = "71" ]; then
/etc/lemp/menu/nangcap-php/setup-php-71.sh
#7.0
###################################
elif [ "$chonphpversion" = "70" ]; then
/etc/lemp/menu/nangcap-php/setup-php-70.sh
###################################
#5.6
###################################
elif [ "$chonphpversion" = "56" ]; then
/etc/lemp/menu/nangcap-php/setup-php-56.sh
###################################
#5.5
###################################
elif [ "$chonphpversion" = "55" ]; then
/etc/lemp/menu/nangcap-php/setup-php-55.sh
###################################
#5.4
###################################
elif [ "$chonphpversion" = "54" ]; then
/etc/lemp/menu/nangcap-php/setup-php-54.sh
else 
clear && /etc/lemp/menu/lemp-update-upgrade-service-menu.sh
fi
