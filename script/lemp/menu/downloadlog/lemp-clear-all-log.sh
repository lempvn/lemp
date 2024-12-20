#!/bin/bash 
. /home/lemp.conf
echo "-------------------------------------------------------------------------"
echo "Please wait ..."
sleep 3
rm -rf /tmp/checksizelog
    cat > "/tmp/checksizelog" <<END
/var/log/nginx/error.log
/home/$mainsite/logs/php-fpm.log
/home/$mainsite/logs/php-fpm-slow.log
/home/$mainsite/logs/php-fpm-error.log
/home/$mainsite/logs/mysql.log
/home/$mainsite/logs/mysql-slow.log
/var/log/secure
END
ls /var/log/exim > /tmp/checkexim
if [ ! "$(du -sb /tmp/checkexim | awk 'NR==1 {print $1}')" == "0" ]; then
listexim=$(cat /tmp/checkexim)
for eximfile in $listexim 
do
echo "/var/log/exim/$eximfile" >> /tmp/checksizelog
done
fi
ls /var/log/redis > /tmp/checkredis
if [ ! "$(du -sb /tmp/checkredis | awk 'NR==1 {print $1}')" == "0" ]; then
listredis=$(cat /tmp/checkredis)
for redisfile in $listredis 
do
echo "/var/log/redis/$redisfile" >> /tmp/checksizelog
done
fi
checklogsize=$(du -ch $(cat /tmp/checksizelog) | tail -1 | cut -f 1)
if [ "$checklogsize" == "0" ]; then
clear
rm -rf /tmp/*check*
echo "========================================================================= "
echo "Khong co du lieu trong cac file log"
/etc/lemp/menu/downloadlog/lemp-error-menu.sh
exit
fi

rm -rf /tmp/error.log
touch /tmp/error.log
chmod -R 600 /tmp/error.log
\cp -uf /tmp/error.log /var/log/nginx/error.log

rm -rf /tmp/php-fpm.log
touch /tmp/php-fpm.log
chmod -R 600 /tmp/php-fpm.log
\cp -uf /tmp/php-fpm.log /home/$mainsite/logs/php-fpm.log

rm -rf /tmp/php-fpm-slow.log
touch /tmp/php-fpm-slow.log
chmod -R 600 /tmp/php-fpm-slow.log
\cp -uf /tmp/php-fpm-slow.log /home/$mainsite/logs/php-fpm-slow.log

rm -rf /tmp/php-fpm-error.log
touch /tmp/php-fpm-error.log
chmod -R 600 /tmp/php-fpm-error.log
\cp -uf /tmp/php-fpm-error.log /home/$mainsite/logs/php-fpm-error.log

rm -rf /tmp/mysql.log
touch /tmp/mysql.log
chmod -R 600 /tmp/mysql.log
\cp -uf /tmp/mysql.log /home/$mainsite/logs/mysql.log

rm -rf /tmp/mysql-slow.log
touch /tmp/mysql-slow.log
chmod -R 600 /tmp/mysql-slow.log
\cp -uf /tmp/mysql-slow.log /home/$mainsite/logs/mysql-slow.log

rm -rf /tmp/secure
touch /tmp/secure
chmod -R 600 /tmp/secure
\cp -uf /tmp/secure /var/log/secure
rm -rf /tmp/secure
rm -rf /var/log/exim/*
rm -rf /var/log/redis/*

clear
rm -rf /tmp/*check*
echo "========================================================================= "
echo "Clear Tat Ca Logs Thanh Cong"
/etc/lemp/menu/downloadlog/lemp-error-menu.sh


