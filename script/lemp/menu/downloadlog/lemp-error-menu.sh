#!/bin/bash
. /home/lemp.conf
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
rm -rf /tmp/*.log
prompt="Lua chon cua ban (0-Thoat):"
options=("Download File Log" "Clear Log File" "Xoa Link Download")
printf "=========================================================================\n"
printf "                LEMP - Quan Ly VPS/Server by LEMP.VN \n"
printf "=========================================================================\n"
printf "                             Quan Ly File Log                           \n"
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

    1) /etc/lemp/menu/downloadlog/lemp-download-log-file-menu-download-only.sh;;
    2) clear && /etc/lemp/menu/downloadlog/lemp-clear-log-server.sh;;
    3) /etc/lemp/menu/downloadlog/lemp-xoa-link-log.sh;;
    #4) clear && /bin/lemp;;
    0) clear && lemp;;
    *) echo "Ban nhap sai, vui long nhap theo so thu tu tren menu !";continue;;

    esac

done

 
