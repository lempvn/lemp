#!/bin/bash 

. /home/lemp.conf
if [ ! -d /home/$mainsite/private_html/server-log ]; then
mkdir -p /home/$mainsite/private_html/server-log
fi
prompt="Nhap lua chon cua ban: "
options=( "Nginx Log" "PHP-FPM Log" "MySQL Log" "PHP-FPM Error Log" "Secure Log" "Exim Log" "PHP-FPM Slow Log" "MySQL Slow Log" "Huy bo")
echo "========================================================================="
echo "Neu file log co dung luong nho hon hoac bang 1 MB"
echo "-------------------------------------------------------------------------"
echo "LEMP se tu dong convert thanh file text de ban xem tren trinh duyet"
echo "========================================================================="
echo "CHON FILE LOG BAN MUON DOWNLOAD"
echo "========================================================================="
PS3="$prompt"
select opt in "${options[@]}"; do 

    case "$REPLY" in
    1) downloadcase="NginxLog"; break;;
    2) downloadcase="phpfpmlog"; break;;
    3) downloadcase="mysqllog"; break;;
    4) downloadcase="phpfpmerrorlog"; break;;
    5) downloadcase="securelog"; break;;
    6) downloadcase="eximlog"; break;;
    7) downloadcase="phpfpmslowlog"; break;;
    8) downloadcase="mysqlslowlog"; break;;
    9) downloadcase="cancle"; break;;
    *) echo "Ban nhap sai, Vui long nhap theo danh sach trong list";continue;;
    esac  
done

if [ "$downloadcase" = "NginxLog" ]; then
/etc/lemp/menu/downloadlog/lemp-download-log-nginx.sh
elif [ "$downloadcase" = "phpfpmlog" ]; then
/etc/lemp/menu/downloadlog/lemp-download-log-php-fpm.sh
elif [ "$downloadcase" = "phpfpmslowlog" ]; then
/etc/lemp/menu/downloadlog/lemp-download-log-php-fpm-slow.sh
elif [ "$downloadcase" = "phpfpmerrorlog" ]; then
/etc/lemp/menu/downloadlog/lemp-download-log-php-fpm-error.sh
elif [ "$downloadcase" = "mysqllog" ]; then
/etc/lemp/menu/downloadlog/lemp-download-log-mysql.sh
elif [ "$downloadcase" = "mysqlslowlog" ]; then
/etc/lemp/menu/downloadlog/lemp-download-log-mysql-slow.sh
elif [ "$downloadcase" = "securelog" ]; then
/etc/lemp/menu/downloadlog/lemp-download-log-secure.sh
elif [ "$downloadcase" = "eximlog" ]; then
/etc/lemp/menu/downloadlog/lemp-download-log-exim.sh
else 
clear && /etc/lemp/menu/downloadlog/lemp-error-menu.sh
fi
