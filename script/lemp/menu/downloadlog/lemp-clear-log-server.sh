#!/bin/bash 

. /home/lemp.conf
if [ ! -d /home/$mainsite/private_html/server-log ]; then
mkdir -p /home/$mainsite/private_html/server-log
fi
if [ -f /home/$mainsite/logs/mysql.log ]; then
mysqllogsize1=$(du -h /home/$mainsite/logs/mysql.log | awk 'NR==1 {print $1}')
	if [ "$mysqllogsize1" = "0" ]; then
	mysqllogsize=0KB
	else
	mysqllogsize=$(du -h /home/$mainsite/logs/mysql.log | awk 'NR==1 {print $1}')
	fi
else
mysqllogsize=0KB
fi
if [ -f /home/$mainsite/logs/mysql-slow.log ]; then
mysqlslow1=$(du -h /home/$mainsite/logs/mysql-slow.log | awk 'NR==1 {print $1}')
	if [ "$mysqlslow1" = "0" ]; then
	mysqlslow=0KB
	else
	mysqlslow=$(du -h /home/$mainsite/logs/mysql-slow.log | awk 'NR==1 {print $1}')
	fi
else
mysqlslow=0KB
fi
if [ -f /home/$mainsite/logs/php-fpm.log ]; then
phpfpmlogsize1=$(du -h /home/$mainsite/logs/php-fpm.log | awk 'NR==1 {print $1}')
	if [ "$phpfpmlogsize1" = "0" ]; then
	phpfpmlogsize=0KB
	else
	phpfpmlogsize=$(du -h /home/$mainsite/logs/php-fpm.log | awk 'NR==1 {print $1}')
	fi
else
php-fpmlogsize=0KB
fi
if [ -f /home/$mainsite/logs/php-fpm-error.log ]; then
phpfpmerrorlogsize1=$(du -h /home/$mainsite/logs/php-fpm-error.log | awk 'NR==1 {print $1}')
	if [ "$phpfpmerrorlogsize1" = "0" ]; then
	phpfpmerrorlogsize=0KB
	else
	phpfpmerrorlogsize=$(du -h /home/$mainsite/logs/php-fpm-error.log | awk 'NR==1 {print $1}')
	fi
else
phpfpmerrorlogsize=0KB
fi
if [ -f /home/$mainsite/logs/php-fpm-slow.log ]; then
phpfpmslowlogsize1=$(du -h /home/$mainsite/logs/php-fpm-slow.log | awk 'NR==1 {print $1}')
	if [ "$phpfpmslowlogsize1" = "0" ]; then
	phpfpmslowlogsize=0KB
	else
	phpfpmslowlogsize=$(du -h /home/$mainsite/logs/php-fpm-slow.log | awk 'NR==1 {print $1}')
	fi
else
phpfpmslowlogsize=0KB
fi
if [ -f /var/log/nginx/error.log ]; then
nginxlogsize1=$(du -h /var/log/nginx/error.log | awk 'NR==1 {print $1}')
	if [ "$nginxlogsize1" = "0" ]; then
	nginxlogsize=0KB
	else
	nginxlogsize=$(du -h /var/log/nginx/error.log | awk 'NR==1 {print $1}')
	fi
else
nginxlogsize=0KB
fi
if [ -f /var/log/secure ]; then
securelogsize1=$(du -h /var/log/secure | awk 'NR==1 {print $1}')
	if [ "$securelogsize1" = "0" ]; then
	securelogsize=0KB
	else
	securelogsize=$(du -h /var/log/secure | awk 'NR==1 {print $1}')
	fi
else
securelogsize=0KB
fi

if [ -f /var/log/exim/main.log ]; then
ls -t /var/log/exim/main.log* > /tmp/eximlog.list
eximlogsize=$(du -ch $(cat /tmp/eximlog.list) | tail -1 | cut -f 1)
else
eximlogsize=0KB
fi
prompt="Lua chon cua ban (0-Thoat):"
options=( "Nginx Log" "PHP-FPM Log" "MySQL Log" "PHP-FPM Error Log" "Secure Log" "Exim Log" "PHP-FPM Slow Log" "MySQL Slow Log" "Xoa Tat Ca Log")
printf "=========================================================================\n"
printf "                LEMP - Quan Ly VPS/Server by LEMP.VN              \n"
printf "=========================================================================\n"
printf "                             Clear Log File                           \n"
printf "=========================================================================\n"
printf "Log File Size: \n"
printf "=========================================================================\n"
printf "Nginx Log: $nginxlogsize | PHP-FPM Log: $phpfpmlogsize | MySQL Log: $mysqllogsize \n"
printf "=========================================================================\n"
printf "PHP-FPM Error Log: $phpfpmerrorlogsize | Secure Log: $securelogsize | Exim Log: $eximlogsize \n"
printf "=========================================================================\n"
printf "PHP-FPM Slow Log: $phpfpmslowlogsize | MySQL Slow Log: $mysqlslow   \n"
printf "=========================================================================\n"
printf "\n"
PS3="$prompt"
select opt in "${options[@]}" ; do 
    case "$REPLY" in
    1) chooseclearcase="NginxLog"; break;;
    2) chooseclearcase="phpfpmlog"; break;;
    3) chooseclearcase="mysqllog"; break;;
    4) chooseclearcase="phpfpmerrorlog"; break;;
    5) chooseclearcase="securelog"; break;;
    6) chooseclearcase="eximlog"; break;;
    7) chooseclearcase="phpfpmslowlog"; break;;
    8) chooseclearcase="mysqlslowlog"; break;;
    9) chooseclearcase="clearalllog"; break;;
    #10) chooseclearcase="cancle"; break;;
    0) chooseclearcase="cancle"; break;;
    *) echo "Ban nhap sai, Vui long nhap theo danh sach trong list";continue;;
    esac  
done



if [ "$chooseclearcase" = "NginxLog" ]; then
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
sleep 1
    checksize=$(du -sb /var/log/nginx/error.log | awk 'NR==1 {print $1}')
	if [ "$checksize" = "0" ]; then
	clear
	echo "========================================================================= "
	echo "Khong co du lieu trong Nginx log file"
	/etc/lemp/menu/downloadlog/lemp-clear-log-server.sh
	fi
	rm -rf /tmp/error.log
touch /tmp/error.log
chmod -R 600 /tmp/error.log
\cp -uf /tmp/error.log /var/log/nginx/error.log
clear
echo "========================================================================= "
echo "Clear Nginx Log thanh cong"
/etc/lemp/menu/downloadlog/lemp-clear-log-server.sh
elif [ "$chooseclearcase" = "phpfpmlog" ]; then
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
sleep 1
   checksize=$(du -sb /home/$mainsite/logs/php-fpm.log | awk 'NR==1 {print $1}')
	if [ "$checksize" = "0" ]; then
	clear
	echo "========================================================================= "
	echo "Khong co du lieu trong PHP-FPM log file"
	/etc/lemp/menu/downloadlog/lemp-clear-log-server.sh
	fi
rm -rf /tmp/php-fpm.log
touch /tmp/php-fpm.log
chmod -R 600 /tmp/php-fpm.log
\cp -uf /tmp/php-fpm.log /home/$mainsite/logs/php-fpm.log
clear
echo "========================================================================= "
echo "Clear PHP-FPM Log thanh cong"
/etc/lemp/menu/downloadlog/lemp-clear-log-server.sh
elif [ "$chooseclearcase" = "phpfpmslowlog" ]; then
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
sleep 1
checksize=$(du -sb /home/$mainsite/logs/php-fpm-slow.log | awk 'NR==1 {print $1}')
	if [ "$checksize" = "0" ]; then
	clear
	echo "========================================================================= "
	echo "Khong co du lieu trong PHP-FPM Slow log file"
	/etc/lemp/menu/downloadlog/lemp-clear-log-server.sh
	fi
rm -rf /tmp/php-fpm-slow.log
touch /tmp/php-fpm-slow.log
chmod -R 600 /tmp/php-fpm-slow.log
\cp -uf /tmp/php-fpm-slow.log /home/$mainsite/logs/php-fpm-slow.log
clear
echo "========================================================================= "
echo "Clear PHP-FPM Slow Log thanh cong"
/etc/lemp/menu/downloadlog/lemp-clear-log-server.sh
elif [ "$chooseclearcase" = "phpfpmerrorlog" ]; then
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
sleep 1
checksize=$(du -sb /home/$mainsite/logs/php-fpm-error.log | awk 'NR==1 {print $1}')
	if [ "$checksize" = "0" ]; then
	clear
	echo "========================================================================= "
	echo "Khong co du lieu trong PHP-FPM Error log file"
	/etc/lemp/menu/downloadlog/lemp-clear-log-server.sh
	fi
rm -rf /tmp/php-fpm-error.log
touch /tmp/php-fpm-error.log
chmod -R 600 /tmp/php-fpm-error.log
\cp -uf /tmp/php-fpm-error.log /home/$mainsite/logs/php-fpm-error.log
clear
echo "========================================================================= "
echo "Clear PHP-FPM Error Log thanh cong"
/etc/lemp/menu/downloadlog/lemp-clear-log-server.sh
elif [ "$chooseclearcase" = "mysqllog" ]; then
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
sleep 1
checksize=$(du -sb /home/$mainsite/logs/mysql.log | awk 'NR==1 {print $1}')
	if [ "$checksize" = "0" ]; then
	clear
	echo "========================================================================= "
	echo "Khong co du lieu trong MySQL log file"
	/etc/lemp/menu/downloadlog/lemp-clear-log-server.sh
	fi
rm -rf /tmp/mysql.log
touch /tmp/mysql.log
chmod -R 600 /tmp/mysql.log
\cp -uf /tmp/mysql.log /home/$mainsite/logs/mysql.log
clear
echo "========================================================================= "
echo "Clear MySQL Log thanh cong"
/etc/lemp/menu/downloadlog/lemp-clear-log-server.sh
elif [ "$chooseclearcase" = "mysqlslowlog" ]; then
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
sleep 1
checksize=$(du -sb /home/$mainsite/logs/mysql-slow.log | awk 'NR==1 {print $1}')
	if [ "$checksize" = "0" ]; then
	clear
	echo "========================================================================= "
	echo "Khong co du lieu trong MySQL Slow log file"
	/etc/lemp/menu/downloadlog/lemp-clear-log-server.sh
	fi
rm -rf /tmp/mysql-slow.log
touch /tmp/mysql-slow.log
chmod -R 600 /tmp/mysql-slow.log
\cp -uf /tmp/mysql-slow.log /home/$mainsite/logs/mysql-slow.log
clear
echo "========================================================================= "
echo "Clear MySQL Slow Log thanh cong"
/etc/lemp/menu/downloadlog/lemp-clear-log-server.sh
elif [ "$chooseclearcase" = "securelog" ]; then
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
sleep 1
checksize=$(du -sb /var/log/secure | awk 'NR==1 {print $1}')
	if [ "$checksize" = "0" ]; then
	clear
	echo "========================================================================= "
	echo "Khong co du lieu trong Secure log file"
	/etc/lemp/menu/downloadlog/lemp-clear-log-server.sh
	fi
rm -rf /tmp/secure
touch /tmp/secure
chmod -R 600 /tmp/secure
\cp -uf /tmp/secure /var/log/secure
rm -rf /tmp/secure
clear
echo "========================================================================= "
echo "Clear Secure Log thanh cong"
/etc/lemp/menu/downloadlog/lemp-clear-log-server.sh
elif [ "$chooseclearcase" = "eximlog" ]; then
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
sleep 1
	if [ ! -f /var/log/exim/main.log ]; then
	clear
	echo "========================================================================= "
	echo "Khong co du lieu trong Exim log file"
	/etc/lemp/menu/downloadlog/lemp-clear-log-server.sh
	fi
rm -rf /var/log/exim/*
clear
echo "========================================================================= "
echo "Clear Exim Log thanh cong"
/etc/lemp/menu/downloadlog/lemp-clear-log-server.sh
elif [ "$chooseclearcase" = "clearalllog" ]; then
/etc/lemp/menu/downloadlog/lemp-clear-all-log.sh
else 
clear && /etc/lemp/menu/downloadlog/lemp-error-menu.sh
fi

